// Borrar todos los paneles existentes (recorre hacia atras)
for (var i = panels.length - 1; i >= 0; i--) {
    panels[i].remove();
}

// 1. Panel Superior (HUD Fijo - 28px)
var topPanel = new Panel();
topPanel.location = "top";
topPanel.height = 28;
topPanel.alignment = "center";
topPanel.hiding = "none";

topPanel.addWidget("org.kde.plasma.pager");
topPanel.addWidget("org.kde.plasma.marginsseparator");

var digitalClockTop = topPanel.addWidget("org.kde.plasma.digitalclock");
digitalClockTop.currentConfigGroup = ["Appearance"];
digitalClockTop.writeConfig("showSeconds", "true");
digitalClockTop.writeConfig("fontFamily", "Exo 2");

topPanel.addWidget("org.kde.plasma.mediacontroller");
topPanel.addWidget("org.kde.plasma.volume");
topPanel.addWidget("org.kde.plasma.marginsseparator");

topPanel.addWidget("org.kde.plasma.systemmonitor.cpucore");
topPanel.addWidget("org.kde.plasma.systemmonitor.memory");
topPanel.addWidget("org.kde.plasma.systemmonitor.net");
topPanel.addWidget("org.kde.plasma.taskmanager");
topPanel.addWidget("org.kde.plasma.notifications");
topPanel.addWidget("org.kde.plasma.showdesktop");

// 2. Panel Inferior (Estilo Windows Clásico - 100%)
var bottomPanel = new Panel();
bottomPanel.location = "bottom";
bottomPanel.alignment = "center";
bottomPanel.hiding = "none";
// lengthMode = "fill" no es una API standard. Usamos length = screen geometry si es posible, 
// o lo dejamos por defecto (que en Plasma suele ser 100%).

bottomPanel.addWidget("org.kde.plasma.kickoff");

var taskManager = bottomPanel.addWidget("org.kde.plasma.taskmanager");
taskManager.currentConfigGroup = ["General"];
taskManager.writeConfig("showOnlyCurrentScreen", "true");
taskManager.writeConfig("groupingStrategy", "1");

bottomPanel.addWidget("org.kde.plasma.colorpicker");
bottomPanel.addWidget("org.kde.plasma.systemtray");

var digitalClockBottom = bottomPanel.addWidget("org.kde.plasma.digitalclock");
digitalClockBottom.currentConfigGroup = ["Appearance"];
digitalClockBottom.writeConfig("showDate", "true");
digitalClockBottom.writeConfig("showSeconds", "true");

bottomPanel.addWidget("org.kde.plasma.showdesktop");
