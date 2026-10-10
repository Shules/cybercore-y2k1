import os

bin_dir = os.path.expanduser("~/.local/bin")
app_dir = os.path.expanduser("~/.local/share/applications/krunner_cmds")

os.makedirs(bin_dir, exist_ok=True)
os.makedirs(app_dir, exist_ok=True)

def create_cmd(name, cmd_string):
    # Create bash script
    bin_path = os.path.join(bin_dir, name)
    with open(bin_path, "w") as f:
        f.write(f"#!/bin/bash\n{cmd_string}\n")
    os.chmod(bin_path, 0o755)
    
    # Create desktop file
    app_path = os.path.join(app_dir, f"{name}.desktop")
    with open(app_path, "w") as f:
        f.write(f"""[Desktop Entry]
Name={name}
Exec={name}
Type=Application
Terminal=false
Icon=utilities-terminal
Categories=Utility;
""")

# Volumes
for v in range(0, 101, 5):
    create_cmd(f"v{v}", f"wpctl set-volume @DEFAULT_AUDIO_SINK@ {v}%\nnotify-send -t 1500 'Volume' 'Set to {v}%'")

# Brightness
for b in range(0, 101, 10):
    if b == 0: b = 1
    create_cmd(f"br{b}", f"brightnessctl set {b}%\nnotify-send -t 1500 'Brightness' 'Set to {b}%'")

# Workspaces
for w in range(1, 11):
    create_cmd(f"w{w}", f"qdbus6 org.kde.KWin /KWin org.kde.KWin.setCurrentDesktop {w}")

# Timers
for t in [1, 5, 10, 15, 20, 30, 45, 60, 90, 120]:
    create_cmd(f"t{t}", f"(sleep {t*60} && notify-send -u critical 'TIMER COMPLETE' 'Timer for {t} mins is up!' --icon=dialog-warning) &\nnotify-send -t 2000 'Timer Set' 'Will alert in {t} minute(s)'")

# Music
create_cmd("mplay", 'playerctl play-pause\nnotify-send -t 1500 "Music" "Play/Pause"')
create_cmd("mpause", 'playerctl pause\nnotify-send -t 1500 "Music" "Pause"')
create_cmd("mnext", 'playerctl next\nnotify-send -t 1500 "Music" "Next"')
create_cmd("mprev", 'playerctl previous\nnotify-send -t 1500 "Music" "Previous"')

print("Created all discrete desktop files.")
