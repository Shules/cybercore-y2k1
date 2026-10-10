var ps = panels();
for (var i = ps.length - 1; i >= 0; i--) {
    ps[i].remove();
}

// TOP PANEL (HUD)
var topPanel = new Panel();
topPanel.location = "top";
topPanel.height = 36;
topPanel.alignment = "center";
topPanel.hiding = "none";
topPanel.floating = 1;

var pager = topPanel.addWidget("org.kde.plasma.pager");
pager.currentConfigGroup = ["General"];
pager.writeConfig("showWindowIcons", "false");
pager.writeConfig("showDesktopString", "true");

topPanel.addWidget("org.kde.plasma.panelspacer");

var clockTop = topPanel.addWidget("org.kde.plasma.digitalclock");
clockTop.currentConfigGroup = ["Appearance"];
clockTop.writeConfig("showDate", "false");
clockTop.writeConfig("showSeconds", "2");

topPanel.addWidget("org.kde.plasma.panelspacer");

topPanel.addWidget("org.kde.plasma.mediacontroller");
topPanel.addWidget("org.kde.plasma.volume");
topPanel.addWidget("org.kde.plasma.notifications");

var cpuIcon = topPanel.addWidget("org.kde.plasma.icon");
cpuIcon.currentConfigGroup = ["General"];
cpuIcon.writeConfig("url", "applications:cybercore-cpu.desktop");
var cpu = topPanel.addWidget("org.kde.plasma.systemmonitor");
cpu.currentConfigGroup = ["Appearance"];
cpu.writeConfig("chartFace", "org.kde.ksysguard.textonly");
cpu.currentConfigGroup = ["Sensors"];
cpu.writeConfig("highPrioritySensorIds", "[\"cpu/all/usage\"]");

var ramIcon = topPanel.addWidget("org.kde.plasma.icon");
ramIcon.currentConfigGroup = ["General"];
ramIcon.writeConfig("url", "applications:cybercore-ram.desktop");
var ram = topPanel.addWidget("org.kde.plasma.systemmonitor");
ram.currentConfigGroup = ["Appearance"];
ram.writeConfig("chartFace", "org.kde.ksysguard.textonly");
ram.currentConfigGroup = ["Sensors"];
ram.writeConfig("highPrioritySensorIds", "[\"memory/physical/used\"]");

var termLauncher = topPanel.addWidget("org.kde.plasma.icon");
termLauncher.currentConfigGroup = ["General"];
termLauncher.writeConfig("url", "applications:cybercore-konsole.desktop");

var sysMonLauncher = topPanel.addWidget("org.kde.plasma.icon");
sysMonLauncher.currentConfigGroup = ["General"];
sysMonLauncher.writeConfig("url", "applications:cybercore-sysmon.desktop");


// BOTTOM PANEL (Taskbar)
var bottomPanel = new Panel();
bottomPanel.location = "bottom";
bottomPanel.height = 42;
bottomPanel.alignment = "center";
bottomPanel.hiding = "none";
bottomPanel.floating = 1;

var kickoff = bottomPanel.addWidget("org.kde.plasma.kickoff");
kickoff.currentConfigGroup = ["General"];
kickoff.writeConfig("icon", "start-here");

bottomPanel.addWidget("org.kde.plasma.icontasks");
bottomPanel.addWidget("org.kde.plasma.panelspacer");
bottomPanel.addWidget("org.kde.plasma.colorpicker");
bottomPanel.addWidget("org.kde.plasma.systemtray");
bottomPanel.addWidget("org.kde.plasma.showdesktop");
