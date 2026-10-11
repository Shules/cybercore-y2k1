import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation
    
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: (sourceName, data) => { disconnectSource(sourceName) }
        function exec(cmd) { connectSource(cmd) }
    }

    fullRepresentation: Item {
        Layout.minimumWidth: 10
        Layout.preferredWidth: 10
        Layout.fillHeight: true

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            
            Rectangle {
                anchors.fill: parent
                color: "#ffffff"
                opacity: mouseArea.containsMouse ? 0.08 : 0.0
            }
            
            onClicked: {
                executable.exec("qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut 'Show Desktop'")
            }
        }
    }
}
