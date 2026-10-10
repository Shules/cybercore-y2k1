#!/bin/bash
set -e

echo "======================================"
echo "Installing Cybercore Y2K1 Environment"
echo "======================================"

# 1. Configs
echo "[1] Applying KDE configs (kdeglobals, kwinrc, dolphinrc, krunnerrc)..."
cp -r config/kde/* ~/.config/
cp -r config/kwin/* ~/.config/
cp -r config/krunner/* ~/.config/

echo "[2] Applying Klassy settings..."
mkdir -p ~/.config/klassy
cp config/klassyrc ~/.config/klassy/

# 2. Themes (Plasma, Kvantum, Color Schemes)
echo "[3] Installing Plasma Desktop Theme..."
mkdir -p ~/.local/share/plasma/desktoptheme/
cp -r themes/plasma/Cybercore-Y2K1 ~/.local/share/plasma/desktoptheme/

echo "[4] Installing Kvantum Theme..."
mkdir -p ~/.config/Kvantum
cp -r themes/kvantum/Cybercore-Y2K1 ~/.config/Kvantum/
kvantummanager --set Cybercore-Y2K1 || echo "Kvantum manager not found, skipping."

echo "[5] Applying Color Scheme..."
mkdir -p ~/.local/share/color-schemes/
cp themes/colors/Cybercore.colors ~/.local/share/color-schemes/
plasma-apply-colorscheme Cybercore

# 3. Konsole
echo "[6] Configuring Konsole..."
mkdir -p ~/.local/share/konsole/
cp config/konsole/Cybercore.colorscheme ~/.local/share/konsole/
cp config/konsole/Cybercore.profile ~/.local/share/konsole/
cp config/konsole/konsolerc ~/.config/

# 4. Fastfetch
echo "[7] Configuring Fastfetch..."
mkdir -p ~/.config/fastfetch/
cp fastfetch/config-compact.jsonc ~/.config/fastfetch/

# 5. KWin Rules (Blur)
echo "[8] Configuring KWin Blur Rules..."
# The user's repo tracks kwinrulesrc but if it doesn't we can inject it
cat << 'KWIN' > ~/.config/kwinrulesrc
[1]
Description=Transparencia Global
opacityactive=98
opacityactiverule=2
opacityinactive=95
opacityinactiverule=2
types=1

[General]
count=1
rules=1
KWIN

# 6. Apply & Reload
# 7. KRunner Scripts
echo "[10] Deploying KRunner Scripts..."
mkdir -p ~/.local/bin
ln -sf $(dirname $(realpath $0))/scripts/krunner/* ~/.local/bin/

# 8. Apply & Reload
echo "[11] Reloading KWin and Plasma..."
qdbus6 org.kde.KWin /KWin reconfigure || true
rm -rf ~/.cache/plasma* || true
rm -rf ~/.cache/krunner* || true

echo "Installation complete! Restart your session or run 'systemctl --user restart plasma-plasmashell' to apply all changes."

# 9. KRunner Desktop Entries
echo "[12] Deploying KRunner Application Entries..."
mkdir -p ~/.local/share/applications/krunner_cmds
cp applications/krunner_cmds/*.desktop ~/.local/share/applications/krunner_cmds/
kbuildsycoca6 --noincremental || true
