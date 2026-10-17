// KWin screen indices may change between logins. Match the connector instead.
(function () {
    var moving = false;
    var watchedOutputs = [];

    function isManaged(window) {
        if (!window || !window.resourceClass) return false;
        var cls = String(window.resourceClass).toLowerCase();
        return cls === 'conky' || cls === 'glava';
    }

    function getTargetY(window, output) {
        var cls = String(window.resourceClass).toLowerCase();
        if (cls === 'glava') {
            return output.geometry.y + 858;
        }
        return output.geometry.y + 56;
    }

    function pin(window) {
        if (moving || !isManaged(window)) return;
        var output = null;
        for (var i = 0; i < workspace.screens.length; i++) {
            if (workspace.screens[i].name === 'DP-2') output = workspace.screens[i];
        }
        // Let KWin keep the window accessible if DP-2 is disconnected.
        if (!output) return;
        moving = true;
        try {
            var cls = String(window.resourceClass).toLowerCase();
            if (window.output !== output) workspace.sendClientToScreen(window, output);
            var rect = window.frameGeometry;
            var w = rect.width > 0 ? rect.width : (cls === 'glava' ? 1920 : 1920);
            var h = rect.height > 0 ? rect.height : (cls === 'glava' ? 180 : 766);
            var x = output.geometry.x;
            var y = getTargetY(window, output);
            if (rect.x !== x || rect.y !== y || rect.width !== w || rect.height !== h) {
                rect.x = x;
                rect.y = y;
                rect.width = w;
                rect.height = h;
                window.frameGeometry = rect;
            }
        } finally {
            moving = false;
        }
    }

    function pinAll() {
        var windows = workspace.windowList();
        for (var i = 0; i < windows.length; i++) pin(windows[i]);
    }

    function watchWindow(window) {
        if (!isManaged(window)) return;
        window.outputChanged.connect(function () { pin(window); });
        window.frameGeometryChanged.connect(function () { pin(window); });
        pin(window);
    }

    function outputsChanged() {
        for (var i = 0; i < workspace.screens.length; i++) {
            var output = workspace.screens[i];
            if (watchedOutputs.indexOf(output) < 0) {
                watchedOutputs.push(output);
                output.geometryChanged.connect(pinAll);
            }
        }
        pinAll();
    }

    workspace.windowAdded.connect(watchWindow);
    workspace.screensChanged.connect(outputsChanged);
    var existing = workspace.windowList();
    for (var i = 0; i < existing.length; i++) watchWindow(existing[i]);
    outputsChanged();
})();
