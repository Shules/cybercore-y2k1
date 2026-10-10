var ps = panels();
for (var i = ps.length - 1; i >= 0; i--) {
    ps[i].remove();
}

// PANEL INFERIOR (KDE Nativo)
var bottomPanel = new Panel();
bottomPanel.location = "bottom";
bottomPanel.alignment = "center";
bottomPanel.hiding = "none";
bottomPanel.lengthMode = "fill";

var kickoff = bottomPanel.addWidget("org.kde.plasma.kickoff");
kickoff.currentConfigGroup = ["General"];
kickoff.writeConfig("icon", "start-here");

// ESCRITORIOS VIRTUALES (Recuperados)
var pager = bottomPanel.addWidget("org.kde.plasma.pager");
pager.currentConfigGroup = ["General"];
pager.writeConfig("showWindowIcons", "false");
pager.writeConfig("showDesktopString", "true");

bottomPanel.addWidget("org.kde.plasma.icontasks");

bottomPanel.addWidget("org.kde.plasma.panelspacer");

// VOLUMEN Y NOTIFICACIONES NATIVAS DE KDE
bottomPanel.addWidget("org.kde.plasma.volume");
bottomPanel.addWidget("org.kde.plasma.notifications");
bottomPanel.addWidget("org.kde.plasma.colorpicker");
bottomPanel.addWidget("org.kde.plasma.systemtray");

var clockBottom = bottomPanel.addWidget("org.kde.plasma.digitalclock");
clockBottom.currentConfigGroup = ["Appearance"];
clockBottom.writeConfig("showDate", "true");
clockBottom.writeConfig("showSeconds", "2");

bottomPanel.addWidget("org.kde.plasma.showdesktop");
