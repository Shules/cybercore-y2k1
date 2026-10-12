import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: (sourceName, data) => { disconnectSource(sourceName) }
        function exec(cmd) { connectSource(cmd) }
    }

    fullRepresentation: Item {
        Layout.minimumWidth: 24
        Layout.preferredWidth: 24
        
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            
            Image {
                anchors.centerIn: parent
                source: "file:///home/julian/.local/share/icons/phosphor/caret-down-light.svg"
                sourceSize.width: 18
                sourceSize.height: 18
                opacity: parent.containsMouse ? 1.0 : 0.7
            }
            
            onClicked: {
                executable.exec("kcmshell6 kcm_pulseaudio")
            }
        }
    }
}
