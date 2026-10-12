#!/bin/bash
set -e

# Always resolve repository directory regardless of where script is called from
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

echo "======================================"
echo "Installing Cybercore Y2K1 Environment"
echo "Working Directory: $BASEDIR"
echo "======================================"

# 0. Base Dependencies (Plasmoids, Icons, Apps)
echo "[0] Installing Plasmoids, Icons and Custom App Entries..."
mkdir -p ~/.local/share/plasma/plasmoids
cp -r "$BASEDIR"/plasmoids/* ~/.local/share/plasma/plasmoids/

mkdir -p ~/.local/share/applications
cp -r "$BASEDIR"/applications/* ~/.local/share/applications/

mkdir -p ~/.local/share/icons
cp -r "$BASEDIR"/icons/theme-overrides/* ~/.local/share/icons/
cp -r "$BASEDIR"/icons/Cybercore-Bars ~/.local/share/icons/
mkdir -p ~/.local/share/icons/phosphor
cp -r "$BASEDIR"/icons/phosphor/* ~/.local/share/icons/phosphor/

gtk-update-icon-cache ~/.local/share/icons/Tango 2>/dev/null || true
gtk-update-icon-cache ~/.local/share/icons/breeze 2>/dev/null || true
gtk-update-icon-cache ~/.local/share/icons/breeze-dark 2>/dev/null || true
gtk-update-icon-cache ~/.local/share/icons/Cybercore-Bars 2>/dev/null || true
rm -rf ~/.cache/icon-cache.kcache 2>/dev/null || true

echo "[0.1] Installing Cybercore Fonts (Exo2, Share Tech Mono, Phosphor, Cyberfonts)..."
mkdir -p ~/.local/share/fonts
cp -r "$BASEDIR"/fonts/* ~/.local/share/fonts/
fc-cache -f ~/.local/share/fonts/ 2>/dev/null || true

# 1. Configs
echo "[1] Applying KDE configs (kdeglobals, kwinrc, dolphinrc, krunnerrc, kwinrulesrc)..."
mkdir -p ~/.config
cp -r "$BASEDIR"/config/kde/* ~/.config/
cp -r "$BASEDIR"/config/kwin/* ~/.config/
cp -r "$BASEDIR"/config/krunner/* ~/.config/

echo "[2] Applying Panel Layout and Shell configs..."
cp "$BASEDIR"/config/plasma-org.kde.plasma.desktop-appletsrc ~/.config/
cp "$BASEDIR"/config/plasmashellrc ~/.config/

echo "[3] Applying Klassy settings..."
mkdir -p ~/.config/klassy
cp "$BASEDIR"/config/klassyrc ~/.config/klassy/

# 2. Themes (Plasma, Kvantum, Color Schemes)
echo "[4] Installing Plasma Desktop Theme..."
mkdir -p ~/.local/share/plasma/desktoptheme/
cp -r "$BASEDIR"/themes/plasma/Cybercore-Y2K1 ~/.local/share/plasma/desktoptheme/

echo "[5] Installing Kvantum Theme..."
mkdir -p ~/.config/Kvantum
cp -r "$BASEDIR"/themes/kvantum/Cybercore-Y2K1 ~/.config/Kvantum/
kvantummanager --set Cybercore-Y2K1 >/dev/null 2>&1 || echo "Kvantum manager not found, skipping."

echo "[6] Applying Color Scheme..."
mkdir -p ~/.local/share/color-schemes/
cp "$BASEDIR"/themes/colors/Cybercore.colors ~/.local/share/color-schemes/
plasma-apply-colorscheme Cybercore >/dev/null 2>&1 || true

# 3. Konsole
echo "[7] Configuring Konsole..."
mkdir -p ~/.local/share/konsole/
cp "$BASEDIR"/config/konsole/Cybercore.colorscheme ~/.local/share/konsole/
cp "$BASEDIR"/config/konsole/Cybercore.profile ~/.local/share/konsole/
cp "$BASEDIR"/config/konsole/konsolerc ~/.config/

# 4. Fastfetch
echo "[8] Configuring Fastfetch..."
mkdir -p ~/.config/fastfetch/
cp "$BASEDIR"/fastfetch/config-compact.jsonc ~/.config/fastfetch/

# 5. KRunner Scripts & Entries
echo "[9] Deploying KRunner Command Scripts..."
mkdir -p ~/.local/bin
for script in "$BASEDIR"/scripts/krunner/*; do
    if [ -f "$script" ]; then
        cp "$script" ~/.local/bin/
        chmod +x ~/.local/bin/"$(basename "$script")"
    fi
done

echo "[10] Deploying KRunner Application Entries..."
mkdir -p ~/.local/share/applications/krunner_cmds
cp "$BASEDIR"/applications/krunner_cmds/*.desktop ~/.local/share/applications/krunner_cmds/
kbuildsycoca6 --noincremental >/dev/null 2>&1 || true

# 6. Secondary Monitor & Desktop Utilities (Conky, Glava & GPU Daemon)
echo "[11] Configuring Secondary Monitor HUD (Conky, Glava, GPU Daemon & Desktop Helpers)..."
mkdir -p ~/.config/conky
cp "$BASEDIR"/config/conky/conky.conf ~/.config/conky/
cp "$BASEDIR"/config/conky/gpu.lua ~/.config/conky/

mkdir -p ~/.config/glava
cp -r "$BASEDIR"/config/glava/* ~/.config/glava/

cp "$BASEDIR"/scripts/cybercore-gpu ~/.local/bin/
cp "$BASEDIR"/scripts/cybercore-gpu-daemon ~/.local/bin/
cp "$BASEDIR"/scripts/cybercore-toggle-desktop ~/.local/bin/
chmod +x ~/.local/bin/cybercore-gpu ~/.local/bin/cybercore-gpu-daemon ~/.local/bin/cybercore-toggle-desktop

# Clean legacy autostarts
rm -f ~/.config/autostart/conky.desktop ~/.config/autostart/glava.desktop 2>/dev/null || true

# Install and enable systemd user services for HUD
mkdir -p ~/.config/systemd/user
cp "$BASEDIR"/config/systemd/*.service ~/.config/systemd/user/
systemctl --user daemon-reload || true
systemctl --user enable --now cybercore-gpu.service conky.service glava.service 2>/dev/null || true

# 7. Apply & Reload
echo "[12] Reloading KWin and Plasma..."
qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
rm -rf ~/.cache/plasma* || true
rm -rf ~/.cache/krunner* || true

echo "=========================================================================="
echo "Installation complete! Restart your session to ensure all services run."
echo "=========================================================================="
