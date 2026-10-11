import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation
    
    Plasmoid.backgroundHints: "NoBackground"

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: (sourceName, data) => { disconnectSource(sourceName) }
        function exec(cmd) { connectSource(cmd) }
    }

    fullRepresentation: Item {
        id: container
        Layout.minimumWidth: 12
        Layout.preferredWidth: 12
        Layout.fillHeight: true

        property var panelRoot: null
        readonly property bool isFloating: panelRoot ? panelRoot.floatingness > 0.01 : false

        Component.onCompleted: {
            var item = container;
            while (item) {
                if (item.floatingness !== undefined) {
                    panelRoot = item;
                    break;
                }
                item = item.parent;
            }
        }

        MouseArea {
            id: mouseArea
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            // When floating: zero bleed so it never escapes the capsule.
            // When docked: bleed to the exact screen edges.
            anchors.topMargin: container.isFloating ? 0 : -4
            anchors.bottomMargin: container.isFloating ? 0 : -4
            anchors.rightMargin: container.isFloating ? 0 : -6
            anchors.leftMargin: 0
            
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            
            Rectangle {
                anchors.fill: parent
                color: "#ffffff"
                opacity: mouseArea.containsMouse ? 0.08 : 0.0
                radius: container.isFloating ? 3 : 0
                
                Behavior on opacity {
                    NumberAnimation { duration: 120 }
                }
            }
            
            onClicked: {
                executable.exec("qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut 'Show Desktop'")
            }
        }
    }
}
