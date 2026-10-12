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

var pager = topPanel.addWidget("org.kde.plasma.pager");
pager.currentConfigGroup = ["General"];
pager.writeConfig("showWindowIcons", "false");
pager.writeConfig("currentDesktopSelected", "1");

topPanel.addWidget("org.kde.plasma.panelspacer");

topPanel.addWidget("org.kde.plasma.mediacontroller");

var clockTop = topPanel.addWidget("org.kde.plasma.digitalclock");
clockTop.currentConfigGroup = ["Appearance"];
clockTop.writeConfig("showDate", "false");
clockTop.writeConfig("showSeconds", "true");

topPanel.addWidget("org.kde.plasma.volume");
topPanel.addWidget("org.kde.plasma.volume"); 

topPanel.addWidget("org.kde.plasma.panelspacer");

var sensors = [
    {id: "cpu/all/usage", title: "CPU"},
    {id: "gpu/all/usage", title: "GPU"},
    {id: "memory/physical/used", title: "RAM"},
    {id: "network/all/download", title: "NET"},
    {id: "lmsensors/k10temp-pci-00c3/Tctl", title: "TMP"}
];

for (var i=0; i<sensors.length; i++) {
    var sm = topPanel.addWidget("org.kde.plasma.systemmonitor");
    sm.currentConfigGroup = ["Appearance"];
    sm.writeConfig("chartFace", "org.kde.ksysguard.horizontalbars");
    sm.writeConfig("title", sensors[i].title);
    sm.currentConfigGroup = ["Sensors"];
    sm.writeConfig("highPrioritySensorIds", "[\"" + sensors[i].id + "\"]");
    sm.writeConfig("totalSensors", "[\"" + sensors[i].id + "\"]");
    topPanel.addWidget("org.kde.plasma.marginsseparator");
}

var sysMonLauncher = topPanel.addWidget("org.kde.plasma.icon");
sysMonLauncher.currentConfigGroup = ["General"];
sysMonLauncher.writeConfig("url", "applications:org.kde.plasma-systemmonitor.desktop");
sysMonLauncher.writeConfig("iconName", "activity");
sysMonLauncher.writeConfig("icon", "activity");

topPanel.addWidget("org.kde.plasma.marginsseparator");

topPanel.addWidget("org.kde.plasma.notifications");

topPanel.addWidget("org.kde.plasma.marginsseparator");

var termLauncher = topPanel.addWidget("org.kde.plasma.icon");
termLauncher.currentConfigGroup = ["General"];
termLauncher.writeConfig("url", "applications:org.kde.konsole.desktop");
termLauncher.writeConfig("iconName", "utilities-terminal");
termLauncher.writeConfig("icon", "utilities-terminal");

topPanel.addWidget("org.kde.plasma.showdesktop");

// 2. PANEL INFERIOR (100%)
var bottomPanel = new Panel();
bottomPanel.location = "bottom";
bottomPanel.alignment = "center";
bottomPanel.hiding = "none";
bottomPanel.lengthMode = "fill";

var kickoff = bottomPanel.addWidget("org.kde.plasma.kickoff");
kickoff.currentConfigGroup = ["General"];
kickoff.writeConfig("icon", "start-here");

bottomPanel.addWidget("org.kde.plasma.icontasks");

bottomPanel.addWidget("org.kde.plasma.panelspacer");

bottomPanel.addWidget("org.kde.plasma.colorpicker");
bottomPanel.addWidget("org.kde.plasma.systemtray");

var clockBottom = bottomPanel.addWidget("org.kde.plasma.digitalclock");
clockBottom.currentConfigGroup = ["Appearance"];
clockBottom.writeConfig("showDate", "true");
clockBottom.writeConfig("showSeconds", "true");

bottomPanel.addWidget("org.kde.plasma.showdesktop");
