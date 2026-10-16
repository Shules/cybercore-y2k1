#!/bin/bash
set -euo pipefail
command -v python3 >/dev/null || { echo "python3 is required" >&2; exit 1; }

# Always resolve repository directory regardless of where script is called from
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASEDIR"

echo "======================================"
echo "Installing Cybercore Y2K1 Environment"
echo "Working Directory: $BASEDIR"
echo "======================================"

# Check for dependency installation skip flag
SKIP_DEPS="${CYBERCORE_SKIP_DEPS:-0}"

# 0. System & AUR Package Dependencies
if [ "$SKIP_DEPS" = "1" ] || [ "${1:-}" = "--no-deps" ]; then
    echo "[0] Skipping package dependency installation (CYBERCORE_SKIP_DEPS=1 or --no-deps passed)."
else
    echo "[0] Checking package dependencies..."

    PACMAN_DEPS=(
        conky
        fastfetch
        yakuake
        kvantum
        ffmpeg
        libcanberra
        pipewire
        pipewire-audio
        wireplumber
    )

    AUR_DEPS=(
        glava
        klassy
        phinger-cursors
    )

    MISSING_PACMAN=()
    for pkg in "${PACMAN_DEPS[@]}"; do
        if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
            MISSING_PACMAN+=("$pkg")
        fi
    done

    MISSING_AUR=()
    for pkg in "${AUR_DEPS[@]}"; do
        if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
            MISSING_AUR+=("$pkg")
        fi
    done

    # Helper detection: yay or paru
    AUR_HELPER=""
    if command -v yay >/dev/null 2>&1; then
        AUR_HELPER="yay"
    elif command -v paru >/dev/null 2>&1; then
        AUR_HELPER="paru"
    fi

    if [ ${#MISSING_PACMAN[@]} -gt 0 ]; then
        echo "Installing missing official packages: ${MISSING_PACMAN[*]}"
        if [ -n "$AUR_HELPER" ]; then
            "$AUR_HELPER" -S --needed --noconfirm "${MISSING_PACMAN[@]}"
        elif command -v sudo >/dev/null 2>&1; then
            sudo pacman -S --needed --noconfirm "${MISSING_PACMAN[@]}"
        else
            pacman -S --needed --noconfirm "${MISSING_PACMAN[@]}"
        fi
    fi

    if [ ${#MISSING_AUR[@]} -gt 0 ]; then
        echo "Installing missing AUR packages: ${MISSING_AUR[*]}"
        if [ -n "$AUR_HELPER" ]; then
            "$AUR_HELPER" -S --needed --noconfirm "${MISSING_AUR[@]}"
        else
            echo "WARNING: Missing AUR packages (${MISSING_AUR[*]}), but neither yay nor paru was found in PATH." >&2
            echo "Please install an AUR helper (yay or paru) or install these packages manually." >&2
        fi
    fi

    if [ ${#MISSING_PACMAN[@]} -eq 0 ] && [ ${#MISSING_AUR[@]} -eq 0 ]; then
        echo "All system and AUR dependencies are already satisfied."
    fi
fi

# 0.1 Base Assets (Plasmoids, Icons, Apps)
echo "[0.1] Installing Plasmoids, Icons and Custom App Entries..."
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

echo "[0.2] Installing Cybercore Sound Theme (Windows Longhorn / Vista Beta)..."
mkdir -p ~/.local/share/sounds
cp -r "$BASEDIR"/sounds/* ~/.local/share/sounds/

echo "[0.3] Installing Cybercore Wallpapers..."
mkdir -p ~/.local/share/wallpapers/Cybercore
cp -r "$BASEDIR"/wallpapers/* ~/.local/share/wallpapers/Cybercore/

# 1. Configs
echo "[1] Applying KDE configs (kdeglobals, kwinrc, dolphinrc, krunnerrc, kwinrulesrc)..."
mkdir -p ~/.config
cp -r "$BASEDIR"/config/kde/* ~/.config/
cp -r "$BASEDIR"/config/kwin/* ~/.config/
cp -r "$BASEDIR"/config/krunner/* ~/.config/

echo "[1.1] Applying GTK and Notification settings..."
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
cp -r "$BASEDIR"/config/gtk-3.0/* ~/.config/gtk-3.0/
cp -r "$BASEDIR"/config/gtk-4.0/* ~/.config/gtk-4.0/
cp "$BASEDIR"/config/plasmanotifyrc ~/.config/
gsettings set org.gnome.desktop.sound theme-name 'Cybercore-Longhorn' 2>/dev/null || true
gsettings set org.gnome.desktop.sound event-sounds true 2>/dev/null || true

echo "[1.2] Deploying Firefox configuration..."
mkdir -p ~/.config/mozilla/firefox
cp "$BASEDIR"/firefox/profiles.ini ~/.config/mozilla/firefox/ 2>/dev/null || true
cp "$BASEDIR"/firefox/installs.ini ~/.config/mozilla/firefox/ 2>/dev/null || true

echo "[1.3] Deploying Vesktop / Vencord configuration and custom commands..."
mkdir -p ~/.config/vesktop/themes
cp -r "$BASEDIR"/vencord/vesktop/* ~/.config/vesktop/ 2>/dev/null || true
if [ -d "$BASEDIR"/vencord/.vesktopCustomCommands ]; then
    cp -r "$BASEDIR"/vencord/.vesktopCustomCommands ~/
    chmod +x ~/.vesktopCustomCommands/*.sh 2>/dev/null || true
fi

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
cp "$BASEDIR"/scripts/cybercore-usb-sound ~/.local/bin/
cp "$BASEDIR"/scripts/cybercore-toggle-desktop ~/.local/bin/
cp "$BASEDIR"/scripts/cybercore-state ~/.local/bin/
cp "$BASEDIR"/scripts/cybercore-backup ~/.local/bin/
cp "$BASEDIR"/scripts/cybercore-restore ~/.local/bin/
chmod +x ~/.local/bin/cybercore-state ~/.local/bin/cybercore-gpu ~/.local/bin/cybercore-gpu-daemon ~/.local/bin/cybercore-usb-sound ~/.local/bin/cybercore-toggle-desktop ~/.local/bin/cybercore-backup ~/.local/bin/cybercore-restore

# Pin Conky by connector name rather than KWin's unstable screen index.
mkdir -p ~/.local/share/kwin/scripts/cybercore-conky-output
cp -r "$BASEDIR"/kwin-scripts/cybercore-conky-output/. ~/.local/share/kwin/scripts/cybercore-conky-output/
kwriteconfig6 --file kwinrc --group Plugins --key cybercore-conky-outputEnabled true
qdbus6 org.kde.KWin /KWin reconfigure

# Clean legacy autostarts
rm -f ~/.config/autostart/conky.desktop ~/.config/autostart/glava.desktop 2>/dev/null || true

# Install and enable systemd user services for HUD & System Audio
mkdir -p ~/.config/systemd/user
cp "$BASEDIR"/config/systemd/*.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user reenable conky.service glava.service cybercore-gpu.service cybercore-usb-sound.service
systemctl --user restart cybercore-gpu.service conky.service glava.service cybercore-usb-sound.service

# Configure Cybercore Show Desktop handler and global shortcuts
echo "[11.1] Configuring Cybercore Show Desktop shortcut and application..."
mkdir -p ~/.local/share/applications
cp "$BASEDIR"/applications/cybercore-toggle-desktop.desktop ~/.local/share/applications/
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group kwin --key "Show Desktop" "none,none,Dar un vistazo al escritorio"
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group services --group cybercore-toggle-desktop.desktop --key _launch "Meta+D,Meta+D,Cybercore Show Desktop"
kbuildsycoca6 --noincremental >/dev/null 2>&1 || true

# 7. Yakuake Drop-Down Terminal
echo "[11.2] Configuring Yakuake Drop-Down Terminal..."
mkdir -p ~/.config ~/.config/autostart
cp "$BASEDIR"/config/yakuake/yakuakerc ~/.config/
cp "$BASEDIR"/config/autostart/org.kde.yakuake.desktop ~/.config/autostart/
kwriteconfig6 --file ~/.config/kglobalshortcutsrc --group yakuake --key "toggle-window-state" "Meta+Y	Ctrl+Alt+T	F12,F12,Abrir/retraer Yakuake"
systemctl --user restart plasma-kglobalaccel >/dev/null 2>&1 || true

# 7. Apply & Reload
echo "[12] Reloading KWin and Plasma..."
qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
rm -rf ~/.cache/plasma* || true
rm -rf ~/.cache/krunner* || true

echo "=========================================================================="
echo "Installation complete! Restart your session to ensure all services run."
echo "=========================================================================="
