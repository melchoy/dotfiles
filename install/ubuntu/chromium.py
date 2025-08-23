#!/usr/bin/env python3

import os
import sys
import json
import shutil
import tempfile
import subprocess
import hashlib
from pathlib import Path

# Constants
INSTALL_ROOT = "/opt/chromium"
BIN = "/opt/chromium/chrome"
SNAP_BASE = "https://commondatastorage.googleapis.com/chromium-browser-snapshots"
HOME = str(Path.home())
PREFS_ROOT = f"{HOME}/.config/chromium"
POLICY_DIR = f"{PREFS_ROOT}/policies/managed"

def get_platform():
  """Get Chromium platform identifier based on architecture."""
  result = subprocess.run(["uname", "-m"], capture_output=True, text=True)
  arch = result.stdout.strip()
  return "Linux_Arm" if arch == "aarch64" else "Linux_x64"

PLATFORM = get_platform()

def run(cmd, check=True, capture_output=False, **kwargs):
  """Run subprocess command with consistent error handling."""
  if capture_output:
    return subprocess.run(cmd, check=check, capture_output=True, text=True, **kwargs)
  return subprocess.run(cmd, check=check, **kwargs)

def curl(url, dst):
  """Download file using curl with retry logic."""
  cmd = ["curl", "-fL", "--retry", "3", "--retry-delay", "1", "-o", str(dst), url]
  run(cmd)

def unzip(zip_path, dst_dir):
  """Extract zip file to destination directory."""
  run(["unzip", "-q", str(zip_path), "-d", str(dst_dir)])

def atomic_write(path, content):
  """Write content to file atomically with fsync."""
  path = Path(path)
  path.parent.mkdir(parents=True, exist_ok=True)

  with tempfile.NamedTemporaryFile(mode='w' if isinstance(content, str) else 'wb',
                                   dir=path.parent, delete=False) as tmp:
    tmp.write(content)
    tmp.flush()
    os.fsync(tmp.fileno())
    temp_path = tmp.name

  os.rename(temp_path, path)

def json_merge(dst_path, patch_dict):
  """Merge patch_dict into JSON file with deep merge and atomic write."""
  dst_path = Path(dst_path)

  # Load existing JSON or start with empty dict
  try:
    with open(dst_path) as f:
      data = json.load(f)
  except (FileNotFoundError, json.JSONDecodeError):
    data = {}

  # Deep merge function
  def deep_merge(base, patch):
    if isinstance(base, dict) and isinstance(patch, dict):
      result = base.copy()
      for key, value in patch.items():
        result[key] = deep_merge(result.get(key), value)
      return result
    return patch if patch is not None else base

  original_data = json.dumps(data, sort_keys=True)
  merged_data = deep_merge(data, patch_dict)
  new_data = json.dumps(merged_data, sort_keys=True)

  if original_data != new_data:
    atomic_write(dst_path, json.dumps(merged_data, indent=2))
    return True
  return False

def read_config(config_dir):
  """Read and merge base config with local overrides."""
  config_dir = Path(config_dir)
  base_file = config_dir / "config.json"
  local_file = config_dir / "config.local.json"

  def load_json(path):
    try:
      with open(path) as f:
        return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
      return {}

  def deep_merge(base, patch):
    if isinstance(base, dict) and isinstance(patch, dict):
      result = base.copy()
      for key, value in patch.items():
        result[key] = deep_merge(result.get(key), value)
      return result
    return patch if patch is not None else base

  base_config = load_json(base_file)
  local_config = load_json(local_file)
  return deep_merge(base_config, local_config)

def resolve_extensions(config_dir, defaults, profile_exts, excludes):
  """Resolve effective extension paths with deduplication."""
  config_dir = Path(config_dir)
  all_extensions = list(defaults) + list(profile_exts)
  exclude_set = set(excludes)

  resolved_paths = []
  seen_paths = set()

  for ext in all_extensions:
    if ext in exclude_set:
      continue

    if ext.startswith('/'):
      full_path = Path(ext)
    else:
      full_path = config_dir / ext

    if full_path.is_dir() and (full_path / "manifest.json").exists():
      abs_path = str(full_path.resolve())
      if abs_path not in seen_paths:
        resolved_paths.append(abs_path)
        seen_paths.add(abs_path)

  return resolved_paths

def get_current_rev():
  """Get current Chromium revision from stored revision file."""
  revision_file = Path(INSTALL_ROOT) / "revision"
  try:
    with open(revision_file) as f:
      return f.read().strip()
  except FileNotFoundError:
    return ""

def get_latest_rev():
  """Get latest Chromium revision from snapshot repository."""
  url = f"{SNAP_BASE}/{PLATFORM}/LAST_CHANGE"
  try:
    result = run(["curl", "-fL", "--retry", "3", "--retry-delay", "1", url],
                 capture_output=True)
    return result.stdout.strip()
  except subprocess.CalledProcessError:
    return ""

def download_snapshot(tmp_dir, revision):
  """Download Chromium snapshot to temporary directory."""
  tmp_dir = Path(tmp_dir)
  zip_url = f"{SNAP_BASE}/{PLATFORM}/{revision}/chrome-linux.zip"
  zip_path = tmp_dir / "chrome-linux.zip"

  print(f"Downloading Chromium {revision} for {PLATFORM}")
  curl(zip_url, zip_path)
  unzip(zip_path, tmp_dir)
  return tmp_dir / "chrome-linux"

def install_snapshot(src_dir, revision):
  """Install Chromium snapshot, replacing existing installation."""
  # Kill any running Chrome processes
  run(["pkill", "-f", "chrome"], check=False)

  # Remove existing installation
  if Path(INSTALL_ROOT).exists():
    run(["sudo", "rm", "-rf", INSTALL_ROOT])

  # Move new installation
  run(["sudo", "mv", str(src_dir), INSTALL_ROOT])
  run(["sudo", "chown", "-R", "root:root", INSTALL_ROOT])
  run(["sudo", "chmod", "+x", BIN])

  # Store revision number for future comparisons
  revision_file = Path(INSTALL_ROOT) / "revision"
  with tempfile.NamedTemporaryFile(mode='w', delete=False) as tmp:
    tmp.write(revision)
    temp_path = tmp.name

  run(["sudo", "mv", temp_path, str(revision_file)])
  run(["sudo", "chmod", "644", str(revision_file)])

  # Create desktop entry
  desktop_content = f"""[Desktop Entry]
Version=1.0
Type=Application
Name=Chromium (Custom)
GenericName=Web Browser
Comment=Browse the World Wide Web
Exec={BIN} %U
Icon=chromium-browser
StartupNotify=true
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;
"""

  desktop_path = "/usr/share/applications/chromium-custom.desktop"
  with tempfile.NamedTemporaryFile(mode='w', delete=False) as tmp:
    tmp.write(desktop_content)
    temp_path = tmp.name

  run(["sudo", "mv", temp_path, desktop_path])
  run(["sudo", "chmod", "644", desktop_path])

  print(f"Chromium {revision} installed")

def install_codecs():
  """Install libffmpeg.so for codec support."""
  lib_dir = Path(INSTALL_ROOT) / "lib"
  run(["sudo", "mkdir", "-p", str(lib_dir)], check=False)

  libffmpeg_path = lib_dir / "libffmpeg.so"

  # Determine source
  if os.getenv("LIBFFMPEG_PATH") and Path(os.getenv("LIBFFMPEG_PATH")).exists():
    run(["sudo", "cp", os.getenv("LIBFFMPEG_PATH"), str(libffmpeg_path)])
  elif os.getenv("LIBFFMPEG_URL"):
    with tempfile.NamedTemporaryFile() as tmp:
      curl(os.getenv("LIBFFMPEG_URL"), tmp.name)
      run(["sudo", "cp", tmp.name, str(libffmpeg_path)])
  else:
    # Auto-fetch from iteufel
    ffmpeg_ver = os.getenv("FFMPEG_AUTO_VER", "0.87.0")
    arch = "arm64" if PLATFORM == "Linux_Arm" else "x64"
    url = f"https://github.com/iteufel/nwjs-ffmpeg-prebuilt/releases/download/{ffmpeg_ver}/{ffmpeg_ver}-linux-{arch}.zip"

    with tempfile.TemporaryDirectory() as tmp_dir:
      zip_path = Path(tmp_dir) / "ffmpeg.zip"
      curl(url, zip_path)
      unzip(zip_path, tmp_dir)

      # Find libffmpeg.so in extracted files
      for ffmpeg_file in Path(tmp_dir).rglob("libffmpeg.so"):
        run(["sudo", "cp", str(ffmpeg_file), str(libffmpeg_path)])
        break
      else:
        raise FileNotFoundError("libffmpeg.so not found in downloaded archive")

  # Verify installation
  try:
    run(["ldd", str(libffmpeg_path)], capture_output=True)
    print("libffmpeg OK")
  except subprocess.CalledProcessError:
    print("Error: libffmpeg verification failed")
    sys.exit(1)

  print("Codecs installed (H.264/AAC/MP3)")

def install_widevine():
  """Install Widevine CDM for DRM support."""
  widevine_dst = Path(INSTALL_ROOT) / "WidevineCdm"
  chrome_widevine = Path("/opt/google/chrome/WidevineCdm")

  if chrome_widevine.exists():
    if widevine_dst.exists():
      run(["sudo", "rm", "-rf", str(widevine_dst)])
    run(["sudo", "cp", "-r", str(chrome_widevine), str(widevine_dst)])

    # Read version from manifest
    manifest_path = widevine_dst / "manifest.json"
    try:
      with open(manifest_path) as f:
        manifest = json.load(f)
      version = manifest.get("version", "unknown")
      print(f"Widevine version: {version}")
    except (FileNotFoundError, json.JSONDecodeError):
      print("Warning: Widevine manifest not found")

    print("Widevine installed")
  else:
    print("Warning: Google Chrome not found, Widevine not available")

def write_policy_file():
  """Write managed policy file for enterprise settings."""
  policy_path = Path(POLICY_DIR) / "dotfiles.json"
  policy_data = {
    "BrowserSignin": 0,
    "SyncDisabled": True,
    "NewTabPageLocation": "about:blank"
  }

  # Check if update needed
  try:
    with open(policy_path) as f:
      current_policy = json.load(f)
    if current_policy == policy_data:
      return
  except (FileNotFoundError, json.JSONDecodeError):
    pass

  atomic_write(policy_path, json.dumps(policy_data))
  print("Policy file written")

def setup_default_preferences():
  """Set up default profile preferences."""
  prefs_dir = Path(PREFS_ROOT) / "Default"
  prefs_dir.mkdir(parents=True, exist_ok=True)

  # Create First Run sentinel
  (prefs_dir / "../First Run").touch()

  # Merge preferences
  prefs_patch = {
    "signin": {"allowed": False},
    "sync": {"requested": False},
    "browser": {"check_default_browser": False},
    "session": {"restore_on_startup": 5, "startup_urls": ["about:blank"]},
    "homepage_is_newtabpage": False,
    "ntp": {"custom_background": {"url": "about:blank"}}
  }

  if json_merge(prefs_dir / "Preferences", prefs_patch):
    print("Preferences updated")

def setup_avatars(config):
  """Set up avatar symlinks if enabled."""
  if not config.get("sync_avatars", False):
    return

  config_dir = Path(os.getenv("CHROMIUM_CONFIG_DIR"))
  avatar_src = config_dir / "avatars"
  if not avatar_src.exists():
    return

  avatar_dst = Path(PREFS_ROOT) / "Avatars"
  avatar_dst.parent.mkdir(parents=True, exist_ok=True)

  if avatar_dst.exists():
    if avatar_dst.is_symlink():
      avatar_dst.unlink()
    else:
      shutil.rmtree(avatar_dst)

  avatar_dst.symlink_to(avatar_src)
  print("Avatars symlinked")

def provision_profiles(config):
  """Provision profile directories and preferences."""
  profiles = config.get("profiles", {})

  # Ensure global "First Run" sentinel
  global_first_run = Path(PREFS_ROOT) / "First Run"
  global_first_run.touch()

  profile_dirs = []

  for name, profile_config in profiles.items():
    pd = profile_config.get("profile_dir")
    disp = profile_config.get("display_name", "")

    if not pd:
      continue

    profile_dirs.append(pd)

    # Create profile folder
    profile_path = Path(PREFS_ROOT) / pd
    profile_path.mkdir(parents=True, exist_ok=True)

    # Touch Preferences if missing (leave empty for merge)
    prefs_file = profile_path / "Preferences"
    if not prefs_file.exists():
      atomic_write(prefs_file, "{}")

    # Touch First Run
    (profile_path / "First Run").touch()

    # Merge profile Preferences (deep merge, atomic write + fsync)
    prefs_patch = {
      "signin": {"allowed": False},
      "sync": {"requested": False},
      "browser": {"check_default_browser": False}
    }

    # Add profile section only if display name is specified
    if disp:
      prefs_patch["profile"] = {"name": disp}

    # Note: Theme configuration temporarily disabled due to crash issues

    changed = json_merge(prefs_file, prefs_patch)
    if changed and disp:
      print(f"Profile name set: {pd} → {disp}")

  # Update Local State to register profiles in picker
  local_state_path = Path(PREFS_ROOT) / "Local State"

  # Load existing Local State or start with empty dict
  try:
    with open(local_state_path) as f:
      local_state = json.load(f)
  except (FileNotFoundError, json.JSONDecodeError):
    local_state = {}

  # Prepare profile section
  profile_section = local_state.get("profile", {})
  info_cache = profile_section.get("info_cache", {})

  # Determine last_used (keep existing if present, else first configured profile_dir)
  last_used = profile_section.get("last_used")
  if not last_used and profile_dirs:
    last_used = profile_dirs[0]

  # Update info_cache for each configured profile_dir
  local_state_changed = False
  for pd in profile_dirs:
    if pd not in info_cache:
      # Add missing profile to info_cache
      info_cache[pd] = {
        "name": "",  # Will be updated from Preferences if display_name is set
        "is_using_default_name": True,
        "avatar_icon": "chrome://theme/IDR_PROFILE_AVATAR_26"
      }
      local_state_changed = True

  # Update from Preferences if display names are available
  for name, profile_config in profiles.items():
    pd = profile_config.get("profile_dir")
    disp = profile_config.get("display_name", "")

    if pd and pd in info_cache:
      current_name = info_cache[pd].get("name", "")
      if disp and current_name != disp:
        info_cache[pd]["name"] = disp
        info_cache[pd]["is_using_default_name"] = False
        local_state_changed = True
      elif not disp and current_name != pd:
        info_cache[pd]["name"] = pd
        info_cache[pd]["is_using_default_name"] = True
        local_state_changed = True

  # Write updated Local State if changed
  if local_state_changed or not local_state_path.exists():
    local_state["profile"] = {
      "last_used": last_used,
      "info_cache": info_cache,
      "picker_shown": True,  # Force profile picker to always show
      "profiles_order": list(profile_dirs)  # Ensure profiles are ordered
    }
    atomic_write(local_state_path, json.dumps(local_state, indent=2))
    print("Local State updated")

def create_profile_launchers(config):
  """Create per-profile launcher scripts."""
  profiles = config.get("profiles", {})
  default_extensions = config.get("default_extensions", [])
  config_dir = os.getenv("CHROMIUM_CONFIG_DIR")

  launcher_dir = Path(HOME) / "bin"
  launcher_dir.mkdir(exist_ok=True)

  common_flags = [
    "--disable-sync",
    "--disable-domain-reliability",
    "--disable-features=ChromeWhatsNewUI,SigninIntercept,SignInProfileCreation",
    "--disable-background-networking",
    "--enable-features=PlatformHEVCDecoderSupport",
    "--ignore-gpu-blocklist",
    "--new-tab-page-url=about:blank"
  ]

  for name, profile_config in profiles.items():
    profile_dir = profile_config.get("profile_dir")
    if not profile_dir:
      continue

    profile_extensions = profile_config.get("extensions", [])
    exclude_extensions = profile_config.get("exclude_extensions", [])

    effective_extensions = resolve_extensions(
      config_dir, default_extensions, profile_extensions, exclude_extensions
    )

    # Create profile picker launcher (default behavior)
    launcher_path = launcher_dir / f"chromium-{name}"
    script_lines = ["#!/bin/bash"]
    cmd_parts = [f'exec {BIN}']

    for flag in common_flags:
      cmd_parts.append(f'  {flag} \\')

    if effective_extensions:
      extensions_csv = ",".join(effective_extensions)
      cmd_parts.append(f'  --load-extension="{extensions_csv}" \\')

    cmd_parts.append('  "$@"')
    script_lines.append(" \\\n".join(cmd_parts[:-1]) + " \\\n" + cmd_parts[-1])

    atomic_write(launcher_path, "\n".join(script_lines))
    os.chmod(launcher_path, 0o755)

    # Create direct profile launcher
    direct_launcher_path = launcher_dir / f"chromium-{name}-direct"
    script_lines = ["#!/bin/bash"]
    cmd_parts = [f'exec {BIN}']

    for flag in common_flags:
      cmd_parts.append(f'  {flag} \\')

    cmd_parts.append(f'  --profile-directory="{profile_dir}" \\')

    if effective_extensions:
      extensions_csv = ",".join(effective_extensions)
      cmd_parts.append(f'  --load-extension="{extensions_csv}" \\')

    cmd_parts.append('  "$@"')
    script_lines.append(" \\\n".join(cmd_parts[:-1]) + " \\\n" + cmd_parts[-1])

    atomic_write(direct_launcher_path, "\n".join(script_lines))
    os.chmod(direct_launcher_path, 0o755)

    ext_count = len(effective_extensions)
    print(f"Profile launcher: {name} → picker (extensions: {ext_count})")
    print(f"Direct launcher: {name}-direct → {profile_dir} (extensions: {ext_count})")

def create_generic_launcher(config):
  """Create generic Chromium launcher."""
  profiles = config.get("profiles", {})

  # Skip creating generic launcher if profiles are configured
  if profiles:
    return

  launcher_path = Path(HOME) / "bin" / "chromium"

  if launcher_path.exists():
    return

  launcher_path.parent.mkdir(exist_ok=True)

  common_flags = [
    "--disable-sync",
    "--disable-domain-reliability",
    "--disable-features=ChromeWhatsNewUI,SigninIntercept,SignInProfileCreation",
    "--disable-background-networking",
    "--enable-features=PlatformHEVCDecoderSupport",
    "--ignore-gpu-blocklist",
    "--new-tab-page-url=about:blank"
  ]

  script_lines = ["#!/bin/bash"]
  cmd_parts = [f'exec {BIN}']

  for flag in common_flags:
    cmd_parts.append(f'  {flag} \\')

  # Check for default theme
  theme = config.get("theme", "")
  config_dir = Path(os.getenv("CHROMIUM_CONFIG_DIR"))
  if theme and (config_dir / "themes" / theme).is_dir():
    theme_path = config_dir / "themes" / theme
    if (theme_path / "manifest.json").exists():
      cmd_parts.append(f'  --load-extension="{theme_path}" \\')
      print(f"Theme wired: {theme}")

  cmd_parts.append('  "$@"')

  script_lines.append(" \\\n".join(cmd_parts[:-1]) + " \\\n" + cmd_parts[-1])

  atomic_write(launcher_path, "\n".join(script_lines))
  os.chmod(launcher_path, 0o755)

def uninstall_chromium():
  """Uninstall Chromium and clean up user data."""
  print("Uninstalling Chromium...")

  # Kill any running Chrome processes
  run(["pkill", "-f", "chrome"], check=False)

  # Remove installation
  if Path(INSTALL_ROOT).exists():
    print(f"Removing {INSTALL_ROOT}")
    run(["sudo", "rm", "-rf", INSTALL_ROOT])

  # Remove user data directory
  if Path(PREFS_ROOT).exists():
    print(f"Removing {PREFS_ROOT}")
    shutil.rmtree(PREFS_ROOT)

  # Remove desktop entry
  desktop_path = "/usr/share/applications/chromium-custom.desktop"
  if Path(desktop_path).exists():
    print(f"Removing {desktop_path}")
    run(["sudo", "rm", "-f", desktop_path])

  # Remove launcher scripts
  bin_dir = Path(HOME) / "bin"
  for launcher in ["chromium", "chromium-flexnet", "chromium-mel"]:
    launcher_path = bin_dir / launcher
    if launcher_path.exists():
      print(f"Removing {launcher_path}")
      launcher_path.unlink()

  print("Chromium uninstalled successfully")

def main():
  """Main installation flow."""
  # Parse arguments
  force_update = "--force" in sys.argv

  if "--uninstall" in sys.argv:
    uninstall_chromium()
    sys.exit(0)

  config_dir = os.getenv("CHROMIUM_CONFIG_DIR")
  if not config_dir:
    print("Error: CHROMIUM_CONFIG_DIR not set")
    sys.exit(1)

  # Debug output
  if os.getenv("DEBUG") == "1":
    config = read_config(config_dir)
    profiles_count = len(config.get("profiles", {}))
    print(f"CONFIG_DIR: {config_dir}")
    print(f"Profiles found: {profiles_count}")

  # Bootstrap config if needed
  config_path = Path(config_dir)
  config_file = config_path / "config.json"
  if not config_file.exists():
    config_path.mkdir(parents=True, exist_ok=True)
    default_config = {
      "sync_avatars": False,
      "theme": "",
      "default_extensions": [],
      "profiles": {}
    }
    atomic_write(config_file, json.dumps(default_config, indent=2))
    print("Chromium config bootstrapped")

  # Load merged configuration
  config = read_config(config_dir)

  # Check if update needed
  current_rev = get_current_rev()
  latest_rev = get_latest_rev()

  if not latest_rev:
    print("Error: Could not fetch latest revision")
    sys.exit(1)

  need_install = not Path(BIN).exists() or force_update or current_rev != latest_rev

  if need_install:
    # Download and install Chromium
    with tempfile.TemporaryDirectory() as tmp_dir:
      src_dir = download_snapshot(tmp_dir, latest_rev)
      install_snapshot(src_dir, latest_rev)

    # Install codecs and Widevine
    install_codecs()
    install_widevine()
  else:
    print(f"Up to date ({current_rev})")

  # Always run these (idempotent)
  write_policy_file()
  setup_default_preferences()
  setup_avatars(config)
  provision_profiles(config)
  create_profile_launchers(config)
  create_generic_launcher(config)

  print("Chromium ready: codecs + Widevine + policies")

if __name__ == "__main__":
  main()
