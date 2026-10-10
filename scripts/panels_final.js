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

topPanel.addWidget("org.kde.plasma.panelspacer"); // Empuja al centro

topPanel.addWidget("org.kde.plasma.mediacontroller");

var clockTop = topPanel.addWidget("org.kde.plasma.digitalclock");
clockTop.currentConfigGroup = ["Appearance"];
clockTop.writeConfig("showDate", "false");
clockTop.writeConfig("showSeconds", "true");
clockTop.writeConfig("fontFamily", "Exo 2");

topPanel.addWidget("org.kde.plasma.volume");
topPanel.addWidget("org.kde.plasma.volume"); // KDE no tiene applet nativo separado solo de mic en la barra, duplicamos para acceder a ambos

topPanel.addWidget("org.kde.plasma.panelspacer"); // Empuja a la derecha

var cpu = topPanel.addWidget("org.kde.plasma.systemmonitor");
cpu.currentConfigGroup = ["Appearance"];
cpu.writeConfig("title", ""); 
cpu.writeConfig("displayStyle", "org.kde.ksysguard.horizontalbars");
cpu.currentConfigGroup = ["Sensors"];
cpu.writeConfig("highPrioritySensorIds", "[\"cpu/all/usage\"]");

topPanel.addWidget("org.kde.plasma.marginsseparator"); // |

var gpu = topPanel.addWidget("org.kde.plasma.systemmonitor");
gpu.currentConfigGroup = ["Appearance"];
gpu.writeConfig("title", ""); 
gpu.writeConfig("displayStyle", "org.kde.ksysguard.horizontalbars");
gpu.currentConfigGroup = ["Sensors"];
gpu.writeConfig("highPrioritySensorIds", "[\"gpu/all/usage\"]");

topPanel.addWidget("org.kde.plasma.marginsseparator"); // |

var mem = topPanel.addWidget("org.kde.plasma.systemmonitor");
mem.currentConfigGroup = ["Appearance"];
mem.writeConfig("title", "");
mem.writeConfig("displayStyle", "org.kde.ksysguard.horizontalbars");
mem.currentConfigGroup = ["Sensors"];
mem.writeConfig("highPrioritySensorIds", "[\"memory/physical/used\"]");

topPanel.addWidget("org.kde.plasma.marginsseparator"); // |

var net = topPanel.addWidget("org.kde.plasma.systemmonitor");
net.currentConfigGroup = ["Appearance"];
net.writeConfig("title", "");
net.writeConfig("displayStyle", "org.kde.ksysguard.horizontalbars");
net.currentConfigGroup = ["Sensors"];
net.writeConfig("highPrioritySensorIds", "[\"network/all/download\"]");

topPanel.addWidget("org.kde.plasma.marginsseparator"); // |

var temp = topPanel.addWidget("org.kde.plasma.systemmonitor");
temp.currentConfigGroup = ["Appearance"];
temp.writeConfig("title", "");
temp.writeConfig("displayStyle", "org.kde.ksysguard.horizontalbars");
temp.currentConfigGroup = ["Sensors"];
temp.writeConfig("highPrioritySensorIds", "[\"lmsensors/k10temp-pci-00c3/Tctl\"]");

topPanel.addWidget("org.kde.plasma.marginsseparator"); // |

var sysMonLauncher = topPanel.addWidget("org.kde.plasma.icon");
sysMonLauncher.currentConfigGroup = ["General"];
sysMonLauncher.writeConfig("url", "applications:org.kde.plasma-systemmonitor.desktop");
sysMonLauncher.writeConfig("icon", "/home/julian/cybercore-y2k1/icons/phosphor/activity-light.svg");

topPanel.addWidget("org.kde.plasma.marginsseparator"); // |

topPanel.addWidget("org.kde.plasma.notifications");

topPanel.addWidget("org.kde.plasma.marginsseparator"); // |

var termLauncher = topPanel.addWidget("org.kde.plasma.icon");
termLauncher.currentConfigGroup = ["General"];
termLauncher.writeConfig("url", "applications:org.kde.konsole.desktop");
termLauncher.writeConfig("icon", "/home/julian/cybercore-y2k1/icons/phosphor/terminal-window-light.svg");

topPanel.addWidget("org.kde.plasma.showdesktop"); // Boton invisible extremo derecho

// 2. PANEL INFERIOR (100%)
var bottomPanel = new Panel();
bottomPanel.location = "bottom";
bottomPanel.alignment = "center";
bottomPanel.hiding = "none";
bottomPanel.lengthMode = "fill";

var kickoff = bottomPanel.addWidget("org.kde.plasma.kickoff");
kickoff.currentConfigGroup = ["General"];
kickoff.writeConfig("icon", "/home/julian/cybercore-y2k1/icons/phosphor/aperture-light.svg");

bottomPanel.addWidget("org.kde.plasma.icontasks");

bottomPanel.addWidget("org.kde.plasma.panelspacer"); // Empuja a la derecha

bottomPanel.addWidget("org.kde.plasma.colorpicker");
bottomPanel.addWidget("org.kde.plasma.systemtray");

var clockBottom = bottomPanel.addWidget("org.kde.plasma.digitalclock");
clockBottom.currentConfigGroup = ["Appearance"];
clockBottom.writeConfig("showDate", "true");
clockBottom.writeConfig("showSeconds", "true");
clockBottom.writeConfig("fontFamily", "Exo 2");

bottomPanel.addWidget("org.kde.plasma.showdesktop"); // Boton invisible extremo derecho
