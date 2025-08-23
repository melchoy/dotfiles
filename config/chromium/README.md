# Chromium Configuration

## Directory Structure

```
config/chromium/
├── config.json     # Main configuration file
├── avatars/        # Custom profile avatars (symlinked if enabled)
├── themes/         # Unpacked Chrome extensions/themes
├── extensions/     # Unpacked Chrome extensions
└── README.md       # This file
```

## Configuration (config.json + config.local.json)

### **Per-Machine Override Support**

The installer supports **deep-merged configuration** where machine-specific overrides in `config.local.json` are merged over the base `config.json`:

- **`config.json`**: Base configuration (committed to git)
- **`config.local.json`**: Machine-specific overrides (not committed)

### **Base Configuration Structure (config.json):**

```json
{
  "theme": "",                    # Default theme name from themes/ directory
  "sync_avatars": false,          # Whether to symlink avatars directory
  "default_extensions": [],       # Extensions loaded for ALL profiles by default
  "profiles": {                   # Per-profile launcher configurations
    "work": {
      "profile_dir": "Profile 1",
      "extensions": ["themes/sample-theme", "extensions/sample-ext"],
      "exclude_extensions": [],     # Extensions to exclude from defaults
      "display_name": "Work Profile"    # Optional: sets profile.name in prefs
    },
    "personal": {
      "profile_dir": "Profile 2",
      "extensions": ["themes/dark-reader"],
      "exclude_extensions": ["extensions/blank-ntp"],  # Don't load this default
      "display_name": "Personal"
    }
  }
}
```

### **Per-Machine Override Example (config.local.json):**

```json
{
  "default_extensions": ["extensions/blank-ntp"],
  "profiles": {
    "flexnet": {
      "profile_dir": "Profile 1",
      "extensions": ["themes/minimal-dark"],   # Adds to defaults
      "display_name": "Flexnet"
    },
    "mel": {
      "profile_dir": "Profile 2",
      "extensions": [],                        # No additional extensions
      "exclude_extensions": ["themes/minimal-dark"],  # Remove this from any defaults
      "display_name": "Mel"
    }
  }
}
```

The installer **deep-merges** these configurations, so the above would completely override the `profiles` section while keeping other base settings.

### **Extension Resolution Logic**

For each profile, extensions are resolved as:

1. **Start with**: `default_extensions` (from merged config)
2. **Add**: `profile.extensions` (additional per-profile extensions)
3. **Remove**: `profile.exclude_extensions` (excluded from the combined set)
4. **De-duplicate and validate**: Only include directories with `manifest.json`

**Example**: With the above config:

- **flexnet** gets: `["extensions/blank-ntp", "themes/minimal-dark"]`
- **mel** gets: `["extensions/blank-ntp"]` (themes/minimal-dark excluded)

## Per-Profile Launchers

### Setup

1. Configure profiles in config.json with profile directory and extensions
2. Place unpacked extensions/themes in respective directories
3. Run `./chromium.sh` to generate profile-specific launchers
4. Launch with `chromium-work` or `chromium-personal` commands

### Generated Launchers

- `~/bin/chromium` - Generic launcher (uses default theme if set)
- `~/bin/chromium-work` - Work profile launcher
- `~/bin/chromium-personal` - Personal profile launcher

## Extension/Theme Setup

### Config-Based Extensions (Optional Pre-loading)

1. Place unpacked Chrome extension in `themes/<name>/` or `extensions/<name>/`
2. Ensure each directory contains a `manifest.json` file
3. Reference in config.json profiles section
4. Run `./chromium.sh` to update launchers

**Important:** Config-based extensions are loaded via `--load-extension` in Developer Mode. This works **alongside** normal extension management:

✅ **You can still:**

- Install extensions from Chrome Web Store
- Load unpacked extensions via `chrome://extensions/`
- Enable/disable extensions dynamically in browser
- Manage extensions through normal Chrome UI

The config just **pre-loads** specific unpacked extensions when launching a profile.

## Avatar Sync

1. Place avatar images in `avatars/` directory
2. Set `"sync_avatars": true` in config.json
3. Run `./chromium.sh` to create symlink

## Always-On Configuration (Dock/Spotlight Launches)

The installer configures Chromium so it behaves correctly **even when launched directly** (not through launchers):

### **Permanent Privacy Settings**

- ✅ **Google sign-in disabled** via preferences + policy
- ✅ **Sync disabled** permanently
- ✅ **No default browser prompts**
- ✅ **Blank New Tab Page** via installed extension + policy

### **Implementation Details**

The installer creates:

1. **Profile Preferences**: `~/Library/Application Support/Chromium/Default/Preferences` (macOS) or `~/.config/chromium/Default/Preferences` (Ubuntu)
2. **Blank NTP Extension**: Built-in extension that overrides new tab page to blank
3. **Policy Enforcement**: `policies/managed/dotfiles.json` as backup enforcement

This means **zero Google API banner** and **no privacy leaks** regardless of how Chromium is launched.

## The installer will automatically:

- Bootstrap config on first run (only creates config.json)
- Use existing dotfiles directories (avatars/, themes/, extensions/)
- Configure Chromium for direct launches (Dock/Spotlight)
- Install blank New Tab Page extension permanently
- Apply privacy policies as backup enforcement
- Symlink avatars if enabled and directory exists
- Generate per-profile launchers with pre-loaded extensions
- Wire default theme to generic launcher

## Other Example Configurations

### Simple with default theme only

```json
{
  "theme": "dark-reader",
  "sync_avatars": true,
  "profiles": {}
}
```

### Development workflow with multiple profiles

```json
{
  "profiles": {
    "dev": {
      "profile_dir": "Profile 1",
      "extensions": ["themes/developer-dark", "extensions/react-devtools"]
    },
    "testing": {
      "profile_dir": "Profile 2",
      "extensions": ["extensions/testing-tools"]
    }
  }
}
```

## Output Example

```bash
# First install with merged config:
./chromium.sh
# Chromium config bootstrapped (first run only)
# Downloading Chromium 123456 for Mac_Arm
# Chromium 123456 installed
# libffmpeg OK
# Codecs installed (H.264/AAC/MP3)
# Widevine version: 4.10.2710.0
# Widevine installed
# Preferences updated
# Installed Blank NTP extension
# Policy file written
# Profile name set: Profile 1 → Flexnet
# Profile launcher: flexnet → Profile 1 (extensions: 2)
# Profile name set: Profile 2 → Mel
# Profile launcher: mel → Profile 2 (extensions: 1)
# Chromium ready: codecs + Widevine + sign-in disabled

# Subsequent runs (if up to date):
./chromium.sh
# Up to date (123456)
# (Only prints if changes made to prefs/extension/policy/launchers)

# Generated launchers:
chromium-flexnet    # Launches with "Flexnet" profile name
chromium-mel        # Launches with "Mel" profile name
~/bin/chromium      # Generic launcher
```

### **Key Features Shown:**

- **Merged Configuration**: `config.local.json` overrides create `flexnet` and `mel` profiles
- **Display Names**: Profile preferences get custom names ("Flexnet", "Mel")
- **Per-Profile Extensions**: Each profile loads its configured extensions
- **Always-On Privacy**: All launch methods (direct/launcher) have privacy settings

## Architecture

### **Python-Based Implementation**

The installer has been refactored to use Python for better maintainability:

```
install/
├── chromium.sh           # Lightweight bash dispatcher
├── mac/chromium.py       # macOS implementation (Python)
└── ubuntu/chromium.py    # Ubuntu/Debian implementation (Python)
```

### **Dispatcher Features**

- **OS Detection**: Automatically detects macOS vs Ubuntu/Debian
- **Environment Setup**: Exports `CHROMIUM_CONFIG_DIR` and `FFMPEG_AUTO_VER`
- **Platform Routing**: Executes appropriate Python implementation

### **Python Implementation Benefits**

- **Pure Stdlib**: Uses only standard library (no external dependencies)
- **Robust Error Handling**: Better exception handling and atomic operations
- **Consistent API**: Shared helper functions across platforms
- **Better Maintenance**: Easier to extend and debug than bash

### **Debug Mode**

```bash
DEBUG=1 ./chromium.sh
# Shows CONFIG_DIR and number of profiles found
```
