import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.private.volume 0.1

PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation

    property var defaultSink: null
    property var defaultSource: null

    SinkModel {
        id: sinkModel
        onRowsInserted: (parent, first, last) => root.updateSink()
        onRowsRemoved: (parent, first, last) => root.updateSink()
        onDataChanged: (topLeft, bottomRight, roles) => root.updateSink()
        onModelReset: root.updateSink()
        onCountChanged: root.updateSink()
    }

    SourceModel {
        id: sourceModel
        onRowsInserted: (parent, first, last) => root.updateSource()
        onRowsRemoved: (parent, first, last) => root.updateSource()
        onDataChanged: (topLeft, bottomRight, roles) => root.updateSource()
        onModelReset: root.updateSource()
        onCountChanged: root.updateSource()
    }

    Component.onCompleted: {
        updateSink();
        updateSource();
    }

    function updateSink() {
        var found = null;
        for (let i = 0; i < sinkModel.count; ++i) {
            let obj = sinkModel.data(sinkModel.index(i, 0), 257);
            if (obj && obj.default) {
                found = obj;
                break;
            }
        }
        if (root.defaultSink !== found) {
            root.defaultSink = found;
        }
    }

    function updateSource() {
        var found = null;
        for (let i = 0; i < sourceModel.count; ++i) {
            let obj = sourceModel.data(sourceModel.index(i, 0), 257);
            if (obj && obj.default) {
                found = obj;
                break;
            }
        }
        if (root.defaultSource !== found) {
            root.defaultSource = found;
        }
    }

    readonly property real sinkVolume: defaultSink ? Math.round((defaultSink.volume / 65536) * 100) : 0
    readonly property bool sinkMuted: defaultSink ? defaultSink.muted : false

    readonly property real sourceVolume: defaultSource ? Math.round((defaultSource.volume / 65536) * 100) : 0
    readonly property bool sourceMuted: defaultSource ? defaultSource.muted : false

    fullRepresentation: Item {
        Layout.minimumWidth: contentRow.implicitWidth
        Layout.maximumWidth: contentRow.implicitWidth
        Layout.preferredWidth: contentRow.implicitWidth

        RowLayout {
            id: contentRow
            anchors.fill: parent
            spacing: 12

            // Output Volume (Sink)
            RowLayout {
                spacing: 6
                Image {
                    source: root.sinkMuted ? "file:///home/julian/.local/share/icons/phosphor/speaker-slash-light.svg" : (root.sinkVolume > 50 ? "file:///home/julian/.local/share/icons/phosphor/speaker-high-light.svg" : "file:///home/julian/.local/share/icons/phosphor/speaker-low-light.svg")
                    sourceSize.width: 18; sourceSize.height: 18
                    Layout.alignment: Qt.AlignVCenter
                    opacity: root.defaultSink ? 1.0 : 0.4
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: root.defaultSink ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            if (root.defaultSink) {
                                root.defaultSink.muted = !root.defaultSink.muted;
                            }
                        }
                    }
                }
                PlasmaComponents.Slider {
                    id: volSlider
                    Layout.preferredWidth: 78
                    Layout.alignment: Qt.AlignVCenter
                    enabled: root.defaultSink !== null
                    from: 0; to: 100
                    value: root.sinkVolume
                    onMoved: {
                        if (pressed && root.defaultSink) {
                            root.defaultSink.volume = Math.round((value / 100) * 65536);
                        }
                    }
                }
            }

            Rectangle { 
                Layout.preferredWidth: 1
                Layout.preferredHeight: 18
                color: "#BD00FF"
                opacity: 0.6
                Layout.alignment: Qt.AlignVCenter 
            }

            // Input Volume (Mic / Source)
            RowLayout {
                spacing: 6
                Image {
                    source: root.sourceMuted ? "file:///home/julian/.local/share/icons/phosphor/microphone-slash-light.svg" : "file:///home/julian/.local/share/icons/phosphor/microphone-light.svg"
                    sourceSize.width: 18; sourceSize.height: 18
                    Layout.alignment: Qt.AlignVCenter
                    opacity: root.defaultSource ? 1.0 : 0.4
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: root.defaultSource ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            if (root.defaultSource) {
                                root.defaultSource.muted = !root.defaultSource.muted;
                            }
                        }
                    }
                }
                PlasmaComponents.Slider {
                    id: micSlider
                    Layout.preferredWidth: 78
                    Layout.alignment: Qt.AlignVCenter
                    enabled: root.defaultSource !== null
                    from: 0; to: 100
                    value: root.sourceVolume
                    onMoved: {
                        if (pressed && root.defaultSource) {
                            root.defaultSource.volume = Math.round((value / 100) * 65536);
                        }
                    }
                }
            }
        }
    }
}
