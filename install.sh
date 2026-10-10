#!/bin/bash
echo "Installing Cybercore Y2K1 Environment..."

# 1. Install Plasmoids
echo "Installing Plasmoids..."
mkdir -p ~/.local/share/plasma/plasmoids
cp -r ./plasmoids/* ~/.local/share/plasma/plasmoids/

# 2. Install Desktop Entries
echo "Installing Application shortcuts..."
mkdir -p ~/.local/share/applications
cp -r ./applications/* ~/.local/share/applications/

# 3. Install Icon Theme Overrides (for the audio arrow hack)
echo "Installing Icon Theme Overrides..."
mkdir -p ~/.local/share/icons
cp -r ./icons/theme-overrides/* ~/.local/share/icons/
gtk-update-icon-cache ~/.local/share/icons/Tango || true
rm -rf ~/.cache/icon-cache.kcache

# 4. Apply Panel Configuration
echo "Applying Panel Configuration..."
cp ./config/plasma-org.kde.plasma.desktop-appletsrc ~/.config/
# Note: In a real fresh install, appending or merging with kwriteconfig6 is safer, 
# but since this is a highly customized locked layout, replacing it is standard for dotfiles.

# 5. Restart Plasma
echo "Restarting Plasma..."
systemctl --user restart plasma-plasmashell.service

echo "Done!"
