import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.ksysguard.sensors as Sensors
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

    Sensors.Sensor { id: cpuSensor; sensorId: "cpu/all/usage" }
    Sensors.Sensor { id: gpuSensor; sensorId: "gpu/gpu0/usage" }
    Sensors.Sensor { id: ramSensor; sensorId: "memory/physical/usedPercent" }
    Sensors.Sensor { id: tempSensor; sensorId: "cpu/all/averageTemperature" }

    fullRepresentation: MouseArea {
        id: mouseArea
        Layout.minimumWidth: contentRow.implicitWidth
        Layout.maximumWidth: contentRow.implicitWidth
        Layout.preferredWidth: contentRow.implicitWidth
        
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: executable.exec("plasma-systemmonitor")

        RowLayout {
            id: contentRow
            anchors.fill: parent
            spacing: 8
            
            // 1. CPU
            RowLayout {
                spacing: 4
                Image {
                    source: "file:///home/julian/.local/share/icons/phosphor/cpu-light.svg"
                    Layout.preferredWidth: 14; Layout.preferredHeight: 14
                    sourceSize.width: 14; sourceSize.height: 14
                }
                PlasmaComponents.Label {
                    text: cpuSensor.formattedValue !== "" ? cpuSensor.formattedValue : "N/A"
                    font.family: "Exo 2"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#00F0FF"; Layout.preferredWidth: 36; horizontalAlignment: Text.AlignRight
                }
            }
            
            Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 12; color: "#BD00FF"; opacity: 0.5 }
            
            // 2. RAM
            RowLayout {
                spacing: 4
                Image {
                    source: "file:///home/julian/.local/share/icons/phosphor/memory-light.svg"
                    Layout.preferredWidth: 14; Layout.preferredHeight: 14
                    sourceSize.width: 14; sourceSize.height: 14
                }
                PlasmaComponents.Label {
                    text: ramSensor.formattedValue !== "" ? ramSensor.formattedValue : "N/A"
                    font.family: "Exo 2"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#00F0FF"; Layout.preferredWidth: 36; horizontalAlignment: Text.AlignRight
                }
            }
            
            Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 12; color: "#BD00FF"; opacity: 0.5 }
            
            // 3. GPU
            RowLayout {
                spacing: 4
                Image {
                    source: "file:///home/julian/.local/share/icons/phosphor/graphics-card-light.svg"
                    Layout.preferredWidth: 14; Layout.preferredHeight: 14
                    sourceSize.width: 14; sourceSize.height: 14
                }
                PlasmaComponents.Label {
                    text: gpuSensor.formattedValue !== "" ? gpuSensor.formattedValue : "N/A"
                    font.family: "Exo 2"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#00F0FF"; Layout.preferredWidth: 26; horizontalAlignment: Text.AlignRight
                }
            }
            
            Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 12; color: "#BD00FF"; opacity: 0.5 }
            
            // 4. TEMPERATURA
            RowLayout {
                spacing: 4
                Image {
                    source: "file:///home/julian/.local/share/icons/phosphor/thermometer-light.svg"
                    Layout.preferredWidth: 14; Layout.preferredHeight: 14
                    sourceSize.width: 14; sourceSize.height: 14
                }
                PlasmaComponents.Label {
                    text: tempSensor.formattedValue !== "" ? tempSensor.formattedValue : "N/A"
                    font.family: "Exo 2"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#00F0FF"; Layout.preferredWidth: 36; horizontalAlignment: Text.AlignRight
                }
            }
        }
    }
}
