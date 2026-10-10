var ps = panels();
for (var i = ps.length - 1; i >= 0; i--) {
    ps[i].remove();
}

// 1. PANEL SUPERIOR (HUD - 28px)
var topPanel = new Panel();
topPanel.location = "top";
topPanel.height = 28;
topPanel.alignment = "center";
topPanel.hiding = "none";

// Izquierda
var pager = topPanel.addWidget("org.kde.plasma.pager");
pager.currentConfigGroup = ["General"];
pager.writeConfig("showWindowIcons", "false");

topPanel.addWidget("org.kde.plasma.marginsseparator");

// Centro
var clockTop = topPanel.addWidget("org.kde.plasma.digitalclock");
clockTop.currentConfigGroup = ["Appearance"];
clockTop.writeConfig("showDate", "false");
clockTop.writeConfig("showSeconds", "true");
clockTop.writeConfig("fontFamily", "Exo 2");

topPanel.addWidget("org.kde.plasma.mediacontroller");
topPanel.addWidget("org.kde.plasma.volume");

topPanel.addWidget("org.kde.plasma.marginsseparator");

// Derecha
var cpu = topPanel.addWidget("org.kde.plasma.systemmonitor.cpucore");
cpu.currentConfigGroup = ["Appearance"];
cpu.writeConfig("title", "CPU");
cpu.writeConfig("displayStyle", "org.kde.ksysguard.textonly");

var mem = topPanel.addWidget("org.kde.plasma.systemmonitor.memory");
mem.currentConfigGroup = ["Appearance"];
mem.writeConfig("title", "RAM");
mem.writeConfig("displayStyle", "org.kde.ksysguard.textonly");

var net = topPanel.addWidget("org.kde.plasma.systemmonitor.net");
net.currentConfigGroup = ["Appearance"];
net.writeConfig("title", "NET");
net.writeConfig("displayStyle", "org.kde.ksysguard.textonly");

var sysMonLauncher = topPanel.addWidget("org.kde.plasma.icon");
sysMonLauncher.currentConfigGroup = ["General"];
sysMonLauncher.writeConfig("url", "applications:org.kde.plasma-systemmonitor.desktop");

topPanel.addWidget("org.kde.plasma.notifications");

var termLauncher = topPanel.addWidget("org.kde.plasma.icon");
termLauncher.currentConfigGroup = ["General"];
termLauncher.writeConfig("url", "applications:org.kde.konsole.desktop");

topPanel.addWidget("org.kde.plasma.showdesktop");

// 2. PANEL INFERIOR (100%)
var bottomPanel = new Panel();
bottomPanel.location = "bottom";
bottomPanel.alignment = "center";
bottomPanel.hiding = "none";
bottomPanel.lengthMode = "fill";

// Izquierda
bottomPanel.addWidget("org.kde.plasma.kickoff");
bottomPanel.addWidget("org.kde.plasma.icontasks");

// Separador para empujar la bandeja de sistema a la derecha
bottomPanel.addWidget("org.kde.plasma.marginsseparator");

// Derecha
bottomPanel.addWidget("org.kde.plasma.colorpicker");
bottomPanel.addWidget("org.kde.plasma.systemtray");

var clockBottom = bottomPanel.addWidget("org.kde.plasma.digitalclock");
clockBottom.currentConfigGroup = ["Appearance"];
clockBottom.writeConfig("showDate", "true");
clockBottom.writeConfig("showSeconds", "true");
clockBottom.writeConfig("fontFamily", "Exo 2");

bottomPanel.addWidget("org.kde.plasma.showdesktop");
