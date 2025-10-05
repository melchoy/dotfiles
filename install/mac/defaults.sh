#!/bin/sh

echo "Setting Default Mac Preferences"

# Close open System Preferences panes, to prevent them from overriding settings.
osascript -e 'tell application "System Preferences" to quit'

# System Preferences
defaults write com.apple.menuextra.clock DateFormat HH:mm:ss # Set clock format.
defaults write NSGlobalDomain AppleLanguage -array "en-AU"   # Set system language.

# Make mac autohide everywhere by default
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# Set Time Zone
# sudo systemsetup -settimezone "Australia/Sydney"

# Dock Settings
defaults write com.apple.dock autohide -bool true      # Autohide dock.
defaults write com.apple.dock tilesize -int 46         # Set dock icon size.
defaults write com.apple.dock magnification -bool true # Enable dock magnification.
defaults write com.apple.dock largesize -int 54        # Set dock magnified icon size.
defaults write NSGlobalDomain AppleInterfaceStyle Dark # Use dark menu bar and dock.
defaults write com.apple.dock persistent-apps -array   # Delete all apps from dock.
defaults write com.apple.dock show-recents -bool false # Turn off "suggested and recent" applications in the Dock.
killall Dock

# Print and Save Panels
defaults write NSGlobalDomain NSNavPanelExpandedStateForPrintMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForPrintMode2 -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Trackpad Settings
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Keyboard Settings
defaults write NSGlobalDomain KeyRepeat -int 1         # Set blazingly fast key repeat rate.
defaults write NSGlobalDomain InitialKeyRepeat -int 12 # Set blazingly fast initial key repeat rate.

# Security and Privacy
defaults write com.apple.LaunchServices LSQuarantine -bool false # Disable the "Are you sure you want to open this application?" dialog.

# Scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false # Disable "natural" scrolling.

# Window Management
defaults write NSGlobalDomain AppleWindowTabbingMode always # Always open new diiocuments in tabs.
defaults write com.apple.dock expose-group-apps -bool true # Mission control display in groups, needed for aerospace

# Text Correction
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false     # Disable automatic capitalization.
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false # Disable period substitution.
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false  # Disable smart quotes.
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false   # Disable smart dashes.
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false # Disable auto-correct.
defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false     # Disable text-completion.

# Finder Settings
defaults write com.apple.finder AppleShowAllFiles -bool false               # Show hidden files.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true             # Show all file extensions.
defaults write com.apple.finder FXEnableExtensionsChangeWarning -bool false # Disable file extension change warning.
defaults write com.apple.finder ShowStatusBar -bool true                    # Show status bar.
defaults write com.apple.finder ShowPathbar -bool true                      # Show path bar.
defaults write com.apple.finder ShowRecentTags -bool false                  # Hide tags in sidebar.
defaults write com.apple.finder QuitMenuItem -bool true                     # Allow quitting finder via ⌘ + Q.
defaults write com.apple.finder SidebarWidth -int 175                       # Greater sidebar width.
defaults write com.apple.finder WarnOnEmptyTrash -bool false                # No warning before emptying trash.
defaults write com.apple.finder FXDefaultSearchScope SCcf                   # Set search scope to current folder.

# Set preferred view style.
# Icon View   : `icnv`
# List View   : `Nlsv`
# Column View : `clmv`
# Cover Flow  : `Flwv`
defaults write com.apple.finder FXPreferredViewStyle icnv
rm -rf ~/.DS_Store

# Set default path for new windows.
# Computer     : `PfCm`
# Volume       : `PfVo`
# $HOME        : `PfHm`
# Desktop      : `PfDe`
# Documents    : `PfDo`
# All My Files : `PfAF`
defaults write com.apple.finder NewWindowTarget PfHm

# Show the ~/Library folder.
chflags nohidden ~/Library

killall Finder

# TextEdit Settings
defaults write com.apple.TextEdit RichText -int 0          # Use plain text mode for new TextEdit documents.
defaults write com.apple.TextEdit PlainTextEncoding -int 4 # Open and save files as UTF-8 in TextEdit.
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Printer Settings
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true # Automatically quit printer app once the print jobs complete.

# Photos Settings
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true # Prevent Photos from opening automatically when devices are plugged in.

# iTunes Settings
# Stop iTunes from responding to the keyboard media keys.
# launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

# SystemUIServer Settings
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
killall SystemUIServer

# Disable app restoration on startup
defaults write com.apple.loginwindow TALAppsToRelaunchAtLogin -array
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

# Reload CoreFoundation preferences
killall cfprefsd
