var ps = panels();
for (var i = ps.length - 1; i >= 0; i--) {
    if (ps[i].location === "top") {
        ps[i].remove();
    }
}

var topPanel = new Panel();
topPanel.location = "top";
topPanel.height = 28;
topPanel.alignment = "center";
topPanel.hiding = "none";

var pager = topPanel.addWidget("org.kde.plasma.pager");
pager.currentConfigGroup = ["General"];
pager.writeConfig("showWindowIcons", "false");
pager.writeConfig("showDesktopString", "true");

topPanel.addWidget("org.kde.plasma.panelspacer");

topPanel.addWidget("org.kde.plasma.mediacontroller");

var clockTop = topPanel.addWidget("org.kde.plasma.digitalclock");
clockTop.currentConfigGroup = ["Appearance"];
clockTop.writeConfig("showDate", "false");
clockTop.writeConfig("showSeconds", "2");

topPanel.addWidget("org.kde.plasma.volume");
var mic = topPanel.addWidget("org.kde.plasma.volume"); 

topPanel.addWidget("org.kde.plasma.panelspacer");

var sensors = [
    "cpu/all/usage",
    "gpu/all/usage",
    "memory/physical/used",
    "network/all/download",
    "lmsensors/k10temp-pci-00c3/Tctl"
];

for (var i=0; i<sensors.length; i++) {
    var sm = topPanel.addWidget("org.kde.plasma.systemmonitor");
    sm.currentConfigGroup = ["Appearance"];
    sm.writeConfig("chartFace", "org.cybercore.telemetry");
    sm.currentConfigGroup = ["Sensors"];
    sm.writeConfig("highPrioritySensorIds", "[\"" + sensors[i] + "\"]");
    sm.writeConfig("totalSensors", "[\"" + sensors[i] + "\"]");
    topPanel.addWidget("org.kde.plasma.marginsseparator");
}

var sysMonLauncher = topPanel.addWidget("org.kde.plasma.icon");
sysMonLauncher.currentConfigGroup = ["General"];
sysMonLauncher.writeConfig("url", "applications:cybercore-sysmon.desktop");

topPanel.addWidget("org.kde.plasma.marginsseparator");

topPanel.addWidget("org.kde.plasma.notifications");

topPanel.addWidget("org.kde.plasma.marginsseparator");

var termLauncher = topPanel.addWidget("org.kde.plasma.icon");
termLauncher.currentConfigGroup = ["General"];
termLauncher.writeConfig("url", "applications:cybercore-konsole.desktop");

topPanel.addWidget("org.kde.plasma.showdesktop");
