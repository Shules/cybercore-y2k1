// KWin screen indices may change between logins. Match the connector instead.
(function () {
    var moving = false;
    var watchedOutputs = [];

    function pin(window) {
        if (moving || String(window.resourceClass).toLowerCase() !== 'conky') return;
        var output = null;
        for (var i = 0; i < workspace.screens.length; i++) {
            if (workspace.screens[i].name === 'DP-2') output = workspace.screens[i];
        }
        // Let KWin keep the window accessible if DP-2 is disconnected.
        if (!output) return;
        moving = true;
        try {
            if (window.output !== output) workspace.sendClientToScreen(window, output);
            var rect = window.frameGeometry;
            var x = output.geometry.x;
            var y = output.geometry.y + 56; // Preserve the former rule's top offset.
            if (rect.x !== x || rect.y !== y) {
                rect.x = x;
                rect.y = y;
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
        if (String(window.resourceClass).toLowerCase() !== 'conky') return;
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
