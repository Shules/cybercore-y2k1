#!/bin/bash
set -e

echo "======================================"
echo "Installing Cybercore Y2K1 Environment"
echo "======================================"

# 0. Base Dependencies (Plasmoids, Icons, Apps)
echo "[0] Installing Plasmoids, Icons and Custom App Entries..."
mkdir -p ~/.local/share/plasma/plasmoids
cp -r ./plasmoids/* ~/.local/share/plasma/plasmoids/ 2>/dev/null || true

mkdir -p ~/.local/share/applications
cp -r ./applications/* ~/.local/share/applications/ 2>/dev/null || true

mkdir -p ~/.local/share/icons
cp -r ./icons/theme-overrides/* ~/.local/share/icons/ 2>/dev/null || true
gtk-update-icon-cache ~/.local/share/icons/Tango 2>/dev/null || true
gtk-update-icon-cache ~/.local/share/icons/breeze 2>/dev/null || true
gtk-update-icon-cache ~/.local/share/icons/breeze-dark 2>/dev/null || true
rm -rf ~/.cache/icon-cache.kcache 2>/dev/null || true

# 1. Configs
echo "[1] Applying KDE configs (kdeglobals, kwinrc, dolphinrc, krunnerrc, kwinrulesrc)..."
cp -r config/kde/* ~/.config/ 2>/dev/null || true
cp -r config/kwin/* ~/.config/ 2>/dev/null || true
cp -r config/krunner/* ~/.config/ 2>/dev/null || true

echo "[2] Applying Panel Layout (HUD)..."
cp config/plasma-org.kde.plasma.desktop-appletsrc ~/.config/

echo "[3] Applying Klassy settings..."
mkdir -p ~/.config/klassy
cp config/klassyrc ~/.config/klassy/ 2>/dev/null || true

# 2. Themes (Plasma, Kvantum, Color Schemes)
echo "[4] Installing Plasma Desktop Theme..."
mkdir -p ~/.local/share/plasma/desktoptheme/
cp -r themes/plasma/Cybercore-Y2K1 ~/.local/share/plasma/desktoptheme/ 2>/dev/null || true

echo "[5] Installing Kvantum Theme..."
mkdir -p ~/.config/Kvantum
cp -r themes/kvantum/Cybercore-Y2K1 ~/.config/Kvantum/ 2>/dev/null || true
kvantummanager --set Cybercore-Y2K1 >/dev/null 2>&1 || echo "Kvantum manager not found, skipping."

echo "[6] Applying Color Scheme..."
mkdir -p ~/.local/share/color-schemes/
cp themes/colors/Cybercore.colors ~/.local/share/color-schemes/ 2>/dev/null || true
plasma-apply-colorscheme Cybercore >/dev/null 2>&1 || true

# 3. Konsole
echo "[7] Configuring Konsole..."
mkdir -p ~/.local/share/konsole/
cp config/konsole/Cybercore.colorscheme ~/.local/share/konsole/ 2>/dev/null || true
cp config/konsole/Cybercore.profile ~/.local/share/konsole/ 2>/dev/null || true
cp config/konsole/konsolerc ~/.config/ 2>/dev/null || true

# 4. Fastfetch
echo "[8] Configuring Fastfetch..."
mkdir -p ~/.config/fastfetch/
cp fastfetch/config-compact.jsonc ~/.config/fastfetch/ 2>/dev/null || true

# 5. KRunner Scripts & Entries
echo "[9] Deploying KRunner Command Scripts..."
mkdir -p ~/.local/bin
cp -r $(dirname $(realpath $0))/scripts/krunner/* ~/.local/bin/ 2>/dev/null || true
chmod +x ~/.local/bin/* 2>/dev/null || true

echo "[10] Deploying KRunner Application Entries..."
mkdir -p ~/.local/share/applications/krunner_cmds
cp applications/krunner_cmds/*.desktop ~/.local/share/applications/krunner_cmds/ 2>/dev/null || true
kbuildsycoca6 --noincremental >/dev/null 2>&1 || true

# 6. Apply & Reload
echo "[11] Reloading KWin and Plasma..."
qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
rm -rf ~/.cache/plasma* || true
rm -rf ~/.cache/krunner* || true

echo "Installation complete! Restart your session or run 'systemctl --user restart plasma-plasmashell' to apply all changes."
