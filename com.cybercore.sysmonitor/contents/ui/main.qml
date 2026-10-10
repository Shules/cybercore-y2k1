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
    Sensors.Sensor { id: gpuSensor; sensorId: "gpu/all/usage" }
    Sensors.Sensor { id: ramSensor; sensorId: "memory/physical/used" }
    Sensors.Sensor { id: tempSensor; sensorId: "lmsensors/k10temp-pci-00c3/Tctl" }

    fullRepresentation: Item {
        implicitWidth: contentRow.implicitWidth
        implicitHeight: contentRow.implicitHeight

        RowLayout {
            id: contentRow
            anchors.fill: parent
            spacing: 8
            
            // 1. CPU
            RowLayout {
                spacing: 4
                Image {
                    source: "file:///home/julian/cybercore-y2k1/icons/phosphor/cpu-light.svg"
                    sourceSize.width: 14; sourceSize.height: 14
                    Layout.alignment: Qt.AlignVCenter
                }
                PlasmaComponents.Label {
                    text: cpuSensor.formattedValue
                    font.family: "Exo 2"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#00F0FF"
                    Layout.alignment: Qt.AlignVCenter
                }
            }
            
            Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 12; Layout.fillWidth: false; color: "#BD00FF"; opacity: 0.5; Layout.alignment: Qt.AlignVCenter }
            
            // 2. RAM
            RowLayout {
                spacing: 4
                Image {
                    source: "file:///home/julian/cybercore-y2k1/icons/phosphor/memory-light.svg"
                    sourceSize.width: 14; sourceSize.height: 14
                    Layout.alignment: Qt.AlignVCenter
                }
                PlasmaComponents.Label {
                    text: ramSensor.formattedValue
                    font.family: "Exo 2"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#00F0FF"
                    Layout.alignment: Qt.AlignVCenter
                }
            }
            
            Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 12; Layout.fillWidth: false; color: "#BD00FF"; opacity: 0.5; Layout.alignment: Qt.AlignVCenter }
            
            // 3. GPU
            RowLayout {
                spacing: 4
                Image {
                    source: "file:///home/julian/cybercore-y2k1/icons/phosphor/graphics-card-light.svg"
                    sourceSize.width: 14; sourceSize.height: 14
                    Layout.alignment: Qt.AlignVCenter
                }
                PlasmaComponents.Label {
                    text: gpuSensor.formattedValue
                    font.family: "Exo 2"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#00F0FF"
                    Layout.alignment: Qt.AlignVCenter
                }
            }
            
            Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 12; Layout.fillWidth: false; color: "#BD00FF"; opacity: 0.5; Layout.alignment: Qt.AlignVCenter }
            
            // 4. TEMPERATURA
            RowLayout {
                spacing: 4
                Image {
                    source: "file:///home/julian/cybercore-y2k1/icons/phosphor/thermometer-light.svg"
                    sourceSize.width: 14; sourceSize.height: 14
                    Layout.alignment: Qt.AlignVCenter
                }
                PlasmaComponents.Label {
                    text: tempSensor.formattedValue !== "" ? tempSensor.formattedValue : "N/A"
                    font.family: "Exo 2"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#00F0FF"
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: {
                executable.exec("plasma-systemmonitor")
            }
        }
    }
}
