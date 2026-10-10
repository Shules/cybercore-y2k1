var ps = panels();
var bottomPanel = null;

// Find the default bottom panel
for (var i = 0; i < ps.length; i++) {
    if (ps[i].location === "bottom") {
        bottomPanel = ps[i];
        break;
    }
}

if (!bottomPanel) {
    bottomPanel = new Panel();
    bottomPanel.location = "bottom";
}

// Clear bottom panel widgets to rebuild it safely
var bottomWidgets = bottomPanel.widgets();
for (var i = 0; i < bottomWidgets.length; i++) {
    bottomWidgets[i].remove();
}

bottomPanel.height = 36;
bottomPanel.alignment = "center";
bottomPanel.hiding = "none";

bottomPanel.addWidget("luisbocanegra.panel.colorizer");
bottomPanel.addWidget("org.kde.plasma.kickoff");
bottomPanel.addWidget("org.kde.plasma.icontasks");
bottomPanel.addWidget("org.kde.plasma.panelspacer");
bottomPanel.addWidget("org.kde.plasma.colorpicker");
bottomPanel.addWidget("org.kde.plasma.systemtray");
bottomPanel.addWidget("org.kde.plasma.showdesktop");

// Create Top Panel
var topPanel = new Panel();
topPanel.location = "top";
topPanel.height = 32;
topPanel.alignment = "center";
topPanel.hiding = "none";

topPanel.addWidget("luisbocanegra.panel.colorizer");

var pager = topPanel.addWidget("org.kde.plasma.pager");
pager.currentConfigGroup = ["General"];
pager.writeConfig("showWindowIcons", "false");
pager.writeConfig("showDesktopString", "true");

topPanel.addWidget("luisbocanegra.panel.colorizer.islands.separator");

topPanel.addWidget("org.kde.plasma.panelspacer");

topPanel.addWidget("luisbocanegra.panel.colorizer.islands.separator");

var clockTop = topPanel.addWidget("org.kde.plasma.digitalclock");
clockTop.currentConfigGroup = ["Appearance"];
clockTop.writeConfig("showDate", "false");
clockTop.writeConfig("showSeconds", "2");

topPanel.addWidget("luisbocanegra.panel.colorizer.islands.separator");

topPanel.addWidget("org.kde.plasma.panelspacer");

topPanel.addWidget("luisbocanegra.panel.colorizer.islands.separator");

topPanel.addWidget("org.kde.plasma.mediacontroller");
topPanel.addWidget("org.kde.plasma.volume");
topPanel.addWidget("org.kde.plasma.notifications");

var sensors = [
    "cpu/all/usage",
    "memory/physical/used"
];
for (var i=0; i<sensors.length; i++) {
    var sm = topPanel.addWidget("org.kde.plasma.systemmonitor");
    sm.currentConfigGroup = ["Appearance"];
    sm.writeConfig("chartFace", "org.kde.ksysguard.textonly");
    sm.currentConfigGroup = ["Sensors"];
    sm.writeConfig("highPrioritySensorIds", "[\"" + sensors[i] + "\"]");
    sm.writeConfig("totalSensors", "[\"" + sensors[i] + "\"]");
}

var termLauncher = topPanel.addWidget("org.kde.plasma.icon");
termLauncher.currentConfigGroup = ["General"];
termLauncher.writeConfig("url", "applications:cybercore-konsole.desktop");

var sysMonLauncher = topPanel.addWidget("org.kde.plasma.icon");
sysMonLauncher.currentConfigGroup = ["General"];
sysMonLauncher.writeConfig("url", "applications:cybercore-sysmon.desktop");

