var ps = panels();
var topPanels = [];
for (var i = 0; i < ps.length; i++) {
    if (ps[i].location === "top") {
        topPanels.push(ps[i]);
    }
}

// Just configure the first top panel (or all of them)
for (var j = 0; j < topPanels.length; j++) {
    var topPanel = topPanels[j];
    var ws = topPanel.widgets();
    for (var i = 0; i < ws.length; i++) {
        ws[i].remove();
    }
    
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
    
    topPanel.addWidget("luisbocanegra.panel.colorizer.islands.separator");
    
    // CPU
    var cpuIcon = topPanel.addWidget("org.kde.plasma.icon");
    cpuIcon.currentConfigGroup = ["General"];
    cpuIcon.writeConfig("url", "applications:cybercore-cpu.desktop");
    var cpu = topPanel.addWidget("org.kde.plasma.systemmonitor");
    cpu.currentConfigGroup = ["Appearance"];
    cpu.writeConfig("chartFace", "org.kde.ksysguard.textonly");
    cpu.currentConfigGroup = ["Sensors"];
    cpu.writeConfig("highPrioritySensorIds", "[\"cpu/all/usage\"]");
    cpu.writeConfig("totalSensors", "[\"cpu/all/usage\"]");
    
    topPanel.addWidget("luisbocanegra.panel.colorizer.islands.separator");
    
    // RAM
    var ramIcon = topPanel.addWidget("org.kde.plasma.icon");
    ramIcon.currentConfigGroup = ["General"];
    ramIcon.writeConfig("url", "applications:cybercore-ram.desktop");
    var ram = topPanel.addWidget("org.kde.plasma.systemmonitor");
    ram.currentConfigGroup = ["Appearance"];
    ram.writeConfig("chartFace", "org.kde.ksysguard.textonly");
    ram.currentConfigGroup = ["Sensors"];
    ram.writeConfig("highPrioritySensorIds", "[\"memory/physical/used\"]");
    ram.writeConfig("totalSensors", "[\"memory/physical/used\"]");
    
    topPanel.addWidget("luisbocanegra.panel.colorizer.islands.separator");
    
    var termLauncher = topPanel.addWidget("org.kde.plasma.icon");
    termLauncher.currentConfigGroup = ["General"];
    termLauncher.writeConfig("url", "applications:cybercore-konsole.desktop");
    
    var sysMonLauncher = topPanel.addWidget("org.kde.plasma.icon");
    sysMonLauncher.currentConfigGroup = ["General"];
    sysMonLauncher.writeConfig("url", "applications:cybercore-sysmon.desktop");
}
