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
        Layout.minimumWidth: 8
        Layout.preferredWidth: 8
        Layout.fillHeight: true

        MouseArea {
            id: mouseArea
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            // Use negative margins to bleed into the panel's padding
            anchors.topMargin: -12
            anchors.bottomMargin: -12
            anchors.rightMargin: -12
            anchors.leftMargin: -4
            
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            
            Rectangle {
                anchors.fill: parent
                color: "#ffffff"
                opacity: mouseArea.containsMouse ? 0.05 : 0.0
            }
            
            onClicked: {
                executable.exec("qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut 'Show Desktop'")
            }
        }
    }
}
