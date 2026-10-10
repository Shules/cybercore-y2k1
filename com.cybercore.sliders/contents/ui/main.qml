import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation
    
    property bool sinkMuted: false
    property bool sourceMuted: false
    property real sinkVolume: 0
    property real sourceVolume: 0

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: (sourceName, data) => {
            disconnectSource(sourceName);
            if (!data || typeof data["stdout"] === "undefined") return;
            var out = data["stdout"].trim();
            
            if (sourceName.indexOf("@DEFAULT_AUDIO_SINK@") !== -1 && sourceName.indexOf("get-volume") !== -1) {
                var volIndex = out.lastIndexOf("Volume:");
                if (volIndex !== -1) {
                    var relevantOut = out.substring(volIndex);
                    var p = relevantOut.split(" ");
                    if (p.length >= 2) {
                        root.sinkVolume = Math.round(parseFloat(p[1]) * 100);
                        root.sinkMuted = relevantOut.indexOf("[MUTED]") !== -1;
                    }
                }
            } 
            
            if (sourceName.indexOf("@DEFAULT_AUDIO_SOURCE@") !== -1 && sourceName.indexOf("get-volume") !== -1) {
                var volIndex2 = out.lastIndexOf("Volume:");
                if (volIndex2 !== -1) {
                    var relevantOut2 = out.substring(volIndex2);
                    var p2 = relevantOut2.split(" ");
                    if (p2.length >= 2) {
                        root.sourceVolume = Math.round(parseFloat(p2[1]) * 100);
                        root.sourceMuted = relevantOut2.indexOf("[MUTED]") !== -1;
                    }
                }
            }
        }
        function exec(cmd) { connectSource(cmd); }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            executable.exec("wpctl get-volume @DEFAULT_AUDIO_SINK@ || echo T" + Date.now());
            executable.exec("wpctl get-volume @DEFAULT_AUDIO_SOURCE@ || echo T" + Date.now());
        }
    }

    Timer {
        id: volDebounce
        interval: 50
        property real targetValue: 0
        onTriggered: {
            executable.exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ " + (targetValue/100).toFixed(2) + " && wpctl get-volume @DEFAULT_AUDIO_SINK@ || echo V" + Date.now());
        }
    }

    Timer {
        id: micDebounce
        interval: 50
        property real targetValue: 0
        onTriggered: {
            executable.exec("wpctl set-volume @DEFAULT_AUDIO_SOURCE@ " + (targetValue/100).toFixed(2) + " && wpctl get-volume @DEFAULT_AUDIO_SOURCE@ || echo M" + Date.now());
        }
    }

    fullRepresentation: RowLayout {
        spacing: 12
        
        Image {
            id: arrowLabel
            source: "file:///home/julian/cybercore-y2k1/icons/phosphor/caret-down-light.svg"
            sourceSize.width: 18; sourceSize.height: 18
            Layout.alignment: Qt.AlignVCenter
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: executable.exec("qdbus6 org.kde.plasmashell /org/kde/osdService org.kde.osdService.volumeChanged 50 && echo DUMMY_" + Date.now())
            }
        }

        RowLayout {
            spacing: 6
            Image {
                source: root.sinkMuted ? "file:///home/julian/cybercore-y2k1/icons/phosphor/speaker-slash-light.svg" : (root.sinkVolume > 50 ? "file:///home/julian/cybercore-y2k1/icons/phosphor/speaker-high-light.svg" : "file:///home/julian/cybercore-y2k1/icons/phosphor/speaker-low-light.svg")
                sourceSize.width: 18; sourceSize.height: 18
                Layout.alignment: Qt.AlignVCenter
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        executable.exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && wpctl get-volume @DEFAULT_AUDIO_SINK@ || echo MUTE_S_" + Date.now());
                    }
                }
            }
            PlasmaComponents.Slider {
                id: volSlider
                Layout.preferredWidth: 78
                
                Layout.alignment: Qt.AlignVCenter
                from: 0; to: 100
                value: root.sinkVolume
                onMoved: {
                    if (pressed) {
                        volDebounce.targetValue = value;
                        volDebounce.restart();
                    }
                }
            }
        }
        
        Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 18; color: "#BD00FF"; opacity: 0.6; Layout.alignment: Qt.AlignVCenter }
        
        RowLayout {
            spacing: 6
            Image {
                source: root.sourceMuted ? "file:///home/julian/cybercore-y2k1/icons/phosphor/microphone-slash-light.svg" : "file:///home/julian/cybercore-y2k1/icons/phosphor/microphone-light.svg"
                sourceSize.width: 18; sourceSize.height: 18
                Layout.alignment: Qt.AlignVCenter
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        executable.exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && wpctl get-volume @DEFAULT_AUDIO_SOURCE@ || echo MUTE_M_" + Date.now());
                    }
                }
            }
            PlasmaComponents.Slider {
                id: micSlider
                Layout.preferredWidth: 78
                
                Layout.alignment: Qt.AlignVCenter
                from: 0; to: 100
                value: root.sourceVolume
                onMoved: {
                    if (pressed) {
                        micDebounce.targetValue = value;
                        micDebounce.restart();
                    }
                }
            }
        }
    }
}
