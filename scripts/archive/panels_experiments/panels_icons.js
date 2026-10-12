var ps = panels();
for (var i=0; i<ps.length; i++) {
    var widgets = ps[i].widgets();
    for (var j=0; j<widgets.length; j++) {
        var w = widgets[j];
        if (w.type === "org.kde.plasma.icon") {
            w.currentConfigGroup = ["General"];
            var url = w.readConfig("url", "");
            if (url.indexOf("konsole") !== -1) {
                w.writeConfig("icon", "/home/julian/cybercore-y2k1/icons/phosphor/terminal-window-light.svg");
            } else if (url.indexOf("systemmonitor") !== -1) {
                w.writeConfig("icon", "/home/julian/cybercore-y2k1/icons/phosphor/activity-light.svg");
            }
        } else if (w.type === "org.kde.plasma.kickoff") {
            w.currentConfigGroup = ["General"];
            w.writeConfig("icon", "/home/julian/cybercore-y2k1/icons/phosphor/aperture-light.svg");
        }
    }
}
