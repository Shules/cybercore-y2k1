const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const source = fs.readFileSync('kwin-scripts/cybercore-conky-output/contents/code/main.js', 'utf8');
function signal() {
    const callbacks = [];
    return {connect(fn) { callbacks.push(fn); }, emit(...args) { callbacks.forEach(fn => fn(...args)); }};
}
function output(name, x) { return {name, geometry: {x, y: 0}, geometryChanged: signal()}; }
function window(resourceClass, output) {
    return {resourceClass, output, frameGeometry: {x: 1920, y: 56, width: 1920, height: 766},
        outputChanged: signal(), frameGeometryChanged: signal()};
}
for (const reverse of [false, true]) {
    const dp1 = output('DP-1', 1920), dp2 = output('DP-2', 0);
    const conky = window('conky', dp1), app = window('firefox', dp1);
    const windows = [conky, app];
    const workspace = {
        screens: reverse ? [dp2, dp1] : [dp1, dp2],
        windowList: () => windows, windowAdded: signal(), screensChanged: signal(),
        sendClientToScreen(w, o) { w.output = o; w.outputChanged.emit(); }
    };
    vm.runInNewContext(source, {workspace});
    assert.equal(conky.output, dp2);
    assert.equal(conky.frameGeometry.x, 0);
    assert.equal(conky.frameGeometry.y, 56);
    assert.equal(app.output, dp1);
    assert.equal(app.frameGeometry.x, 1920);
    workspace.screens = [dp1]; workspace.screensChanged.emit();
    conky.output = dp1; conky.frameGeometry.x = 1920; conky.outputChanged.emit();
    assert.equal(conky.output, dp1);
    workspace.screens = [dp1, dp2]; workspace.screensChanged.emit();
    assert.equal(conky.output, dp2);
    dp2.geometry = {x: -1920, y: 100}; dp2.geometryChanged.emit();
    assert.equal(conky.frameGeometry.x, -1920);
    assert.equal(conky.frameGeometry.y, 156);
    const restarted = window('conky', dp1); windows.push(restarted);
    workspace.windowAdded.emit(restarted);
    assert.equal(restarted.output, dp2);
}
// DP-2 becomes available after Conky starts.
{
    const dp1=output('DP-1',0), dp2=output('DP-2',1920), conky=window('conky',dp1);
    const workspace={screens:[dp1],windowList:()=>[conky],windowAdded:signal(),screensChanged:signal(),sendClientToScreen(w,o){w.output=o;}};
    vm.runInNewContext(source,{workspace});
    assert.equal(conky.output,dp1);
    workspace.screens.push(dp2); workspace.screensChanged.emit();
    assert.equal(conky.output,dp2);
    assert.equal(conky.frameGeometry.x,1920);
}
console.log('PASS: output order, reconnect, delayed DP-2, geometry, existing windows, other apps untouched');
