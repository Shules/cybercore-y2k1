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

    fullRepresentation: MouseArea {
        id: mouseArea
        Layout.minimumWidth: 24
        Layout.preferredWidth: 24
        
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        Image {
            anchors.centerIn: parent
            source: "file:///home/julian/cybercore-y2k1/icons/phosphor/terminal-window-light.svg"
            sourceSize.width: 18
            sourceSize.height: 18
        }
        
        onClicked: {
            executable.exec("konsole")
        }
    }
}
