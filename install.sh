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

# 6. Apply Klassy Settings
echo "Applying Klassy Settings..."
mkdir -p ~/.config/klassy
cp ./config/klassyrc ~/.config/klassy/
qdbus6 org.kde.KWin /KWin reconfigure

# 7. Apply System Colors (kdeglobals)
echo "Applying Window Button Hover Colors..."
kwriteconfig6 --file ~/.config/kdeglobals --group "Colors:Button" --key DecorationHover "0,240,255"
kwriteconfig6 --file ~/.config/kdeglobals --group "Colors:Window" --key DecorationHover "0,240,255"
# Reload KWin to pick up global color changes
qdbus6 org.kde.KWin /KWin reconfigure

# --- FASE 2: Kvantum, KWin y Dolphin ---
echo "Instalando tema Kvantum Cybercore-Y2K1..."
mkdir -p ~/.config/Kvantum
cp -r config/Kvantum/Cybercore-Y2K1 ~/.config/Kvantum/
cp config/Kvantum/kvantum.kvconfig ~/.config/Kvantum/
kvantummanager --set Cybercore-Y2K1

echo "Configurando KWin (Transparencia global y Dolphin)..."
cat << 'KWIN' > ~/.config/kwinrulesrc
[1]
Description=Forzar Blur en Dolphin
opacityactive=99
opacityactiverule=2
opacityinactive=99
opacityinactiverule=2
wmclass=dolphin
wmclasscomplete=false
wmclassmatch=1
types=1

[General]
count=1
rules=1
KWIN
qdbus6 org.kde.KWin /KWin reconfigure

echo "Configurando grilla rígida en Dolphin..."
kwriteconfig6 --file dolphinrc --group IconsMode --key MaximumTextLines 2
kwriteconfig6 --file dolphinrc --group IconsMode --key TextWidthIndex 1
