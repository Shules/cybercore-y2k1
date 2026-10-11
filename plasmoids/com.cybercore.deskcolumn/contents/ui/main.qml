import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation
    
    Plasmoid.backgroundHints: "NoBackground"



    // Colors
    readonly property color iceWhite: "#E0F8FF"
    readonly property color electricCyan: "#00F0FF"
    readonly property color neonViolet: "#A200FF"
    readonly property color bgCard: "#15051A"
    readonly property color mutedViolet: "#8D7CA6"

    // Current Date/Time tracking
    property var now: new Date()
    property string timeStr: "00:00:00"
    property string dateStr: ""

    // Weather Data (Córdoba Capital)
    property string weatherTemp: "--"
    property string weatherCondition: "Cargando clima..."
    property string weatherHumidity: "--%"
    property string weatherWind: "-- km/h"
    property string weatherIcon: "file:///home/julian/cybercore-y2k1/icons/phosphor/cloud-sun-light.svg"

    // Media Data
    property string mediaTitle: "Reproductor inactivo"
    property string mediaArtist: "Cybercore MPRIS"
    property string mediaStatus: "Stopped"
    property bool mediaPlaying: false

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.now = new Date();
            var h = String(root.now.getHours()).padStart(2, '0');
            var m = String(root.now.getMinutes()).padStart(2, '0');
            var s = String(root.now.getSeconds()).padStart(2, '0');
            root.timeStr = h + ":" + m + ":" + s;

            var days = ["DOMINGO", "LUNES", "MARTES", "MIÉRCOLES", "JUEVES", "VIERNES", "SÁBADO"];
            var monthsShort = ["ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"];
            var dayNum = String(root.now.getDate()).padStart(2, '0');
            root.dateStr = "SYS.DATE: " + dayNum + "-" + monthsShort[root.now.getMonth()] + " // " + days[root.now.getDay()];
        }
    }

    Timer {
        interval: 900000 // 15 mins
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: fetchWeather()
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            execDataSource.exec("playerctl metadata --format '{{title}};;;{{artist}};;;{{status}}' 2>/dev/null || echo 'NONE'")
        }
    }

    Plasma5Support.DataSource {
        id: execDataSource
        engine: "executable"
        connectedSources: []
        onNewData: (sourceName, data) => {
            disconnectSource(sourceName);
            var out = data["stdout"] ? data["stdout"].trim() : "";
            if (out && out !== "NONE" && out.indexOf(";;;") !== -1) {
                var parts = out.split(";;;");
                root.mediaTitle = parts[0] || "Pista en curso";
                root.mediaArtist = parts[1] || "Artista desconocido";
                root.mediaStatus = parts[2] || "Playing";
                root.mediaPlaying = (root.mediaStatus.toLowerCase() === "playing");
            } else {
                root.mediaTitle = "Sin reproducción activa";
                root.mediaArtist = "Módulo listo // Esperando MPRIS";
                root.mediaPlaying = false;
            }
        }
        function exec(cmd) { connectSource(cmd) }
    }

    function fetchWeather() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "https://api.open-meteo.com/v1/forecast?latitude=-31.42&longitude=-64.19&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&timezone=America%2FArgentina%2FCordoba");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                try {
                    var data = JSON.parse(xhr.responseText);
                    var cur = data.current;
                    root.weatherTemp = Math.round(cur.temperature_2m) + "°C";
                    root.weatherHumidity = cur.relative_humidity_2m + "%";
                    root.weatherWind = Math.round(cur.wind_speed_10m) + " km/h";
                    
                    var code = cur.weather_code;
                    var baseIcon = "file:///home/julian/cybercore-y2k1/icons/phosphor/";
                    if (code === 0) {
                        root.weatherCondition = "Despejado";
                        root.weatherIcon = baseIcon + "sun-light.svg";
                    } else if (code === 1) {
                        root.weatherCondition = "Mayormente despejado";
                        root.weatherIcon = baseIcon + "sun-dim-light.svg";
                    } else if (code === 2) {
                        root.weatherCondition = "Parcialmente nublado";
                        root.weatherIcon = baseIcon + "cloud-sun-light.svg";
                    } else if (code === 3) {
                        root.weatherCondition = "Nublado";
                        root.weatherIcon = baseIcon + "cloud-light.svg";
                    } else if (code >= 45 && code <= 48) {
                        root.weatherCondition = "Niebla";
                        root.weatherIcon = baseIcon + "cloud-fog-light.svg";
                    } else if (code >= 51 && code <= 55) {
                        root.weatherCondition = "Llovizna";
                        root.weatherIcon = baseIcon + "cloud-rain-light.svg";
                    } else if (code >= 56 && code <= 57) {
                        root.weatherCondition = "Llovizna helada";
                        root.weatherIcon = baseIcon + "cloud-snow-light.svg";
                    } else if (code >= 61 && code <= 65) {
                        root.weatherCondition = "Lluvia";
                        root.weatherIcon = baseIcon + "cloud-rain-light.svg";
                    } else if (code >= 66 && code <= 67) {
                        root.weatherCondition = "Lluvia helada";
                        root.weatherIcon = baseIcon + "cloud-snow-light.svg";
                    } else if (code >= 71 && code <= 77) {
                        root.weatherCondition = "Nevada";
                        root.weatherIcon = baseIcon + "cloud-snow-light.svg";
                    } else if (code >= 80 && code <= 82) {
                        root.weatherCondition = "Chubascos";
                        root.weatherIcon = baseIcon + "cloud-rain-light.svg";
                    } else if (code >= 85 && code <= 86) {
                        root.weatherCondition = "Chubascos de nieve";
                        root.weatherIcon = baseIcon + "cloud-snow-light.svg";
                    } else if (code >= 95 && code <= 99) {
                        root.weatherCondition = "Tormenta eléctrica";
                        root.weatherIcon = baseIcon + "cloud-lightning-light.svg";
                    } else {
                        root.weatherCondition = "Nublado";
                        root.weatherIcon = baseIcon + "cloud-light.svg";
                    }
                } catch(e) {}
            }
        };
        xhr.send();
    }

    fullRepresentation: Item {
        id: container
        width: 320
        height: columnLayout.implicitHeight

        ColumnLayout {
            id: columnLayout
            width: 320
            spacing: 24

            // ==========================================
            // 1. RELOJ FLOTANTE
            // ==========================================
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: "[ " + root.timeStr + " ]"
                    font.family: "Share Tech Mono"
                    font.pixelSize: 44
                    color: root.iceWhite
                    Layout.alignment: Qt.AlignRight
                }

                Text {
                    text: root.dateStr
                    font.family: "Share Tech Mono"
                    font.pixelSize: 13
                    color: root.neonViolet
                    Layout.alignment: Qt.AlignRight
                }

                // Línea técnica separadora
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: root.electricCyan
                    opacity: 0.4
                    Layout.topMargin: 8
                }
            }

            // ==========================================
            // 2. CALENDARIO MINIMALISTA
            // ==========================================
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 12

                // Mes / Año
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: {
                            var months = ["ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"];
                            return months[root.now.getMonth()] + " " + root.now.getFullYear();
                        }
                        font.family: "Exo 2"
                        font.pixelSize: 14
                        font.bold: true
                        color: root.neonViolet
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: "CYBERCORE CAL"
                        font.family: "Exo 2"
                        font.pixelSize: 10
                        font.bold: true
                        color: root.iceWhite
                        opacity: 0.7
                    }
                }

                // Días semana
                GridLayout {
                    columns: 7
                    columnSpacing: 6
                    rowSpacing: 6
                    Layout.fillWidth: true

                    Repeater {
                        model: ["D", "L", "M", "M", "J", "V", "S"]
                        Text {
                            text: modelData
                            font.family: "Exo 2"
                            font.pixelSize: 11
                            font.bold: true
                            color: root.iceWhite
                            opacity: 0.85
                            horizontalAlignment: Text.AlignHCenter
                            Layout.fillWidth: true
                        }
                    }

                    // Celdas del mes
                    Repeater {
                        model: {
                            var year = root.now.getFullYear();
                            var month = root.now.getMonth();
                            var firstDay = new Date(year, month, 1).getDay();
                            var daysInMonth = new Date(year, month + 1, 0).getDate();
                            var cells = [];
                            
                            // Días vacíos previos
                            for (var i = 0; i < firstDay; i++) {
                                cells.push({ day: "", isCurrent: false });
                            }
                            // Días reales
                            for (var d = 1; d <= daysInMonth; d++) {
                                cells.push({ day: d, isCurrent: (d === root.now.getDate()) });
                            }
                            return cells;
                        }

                        Rectangle {
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 28
                            Layout.alignment: Qt.AlignCenter
                            color: modelData.isCurrent ? root.neonViolet : "transparent"
                            border.color: modelData.isCurrent ? root.electricCyan : "transparent"
                            border.width: modelData.isCurrent ? 1 : 0
                            radius: modelData.isCurrent ? 2 : 0

                            Text {
                                anchors.centerIn: parent
                                text: modelData.day
                                font.family: "Exo 2"
                                font.pixelSize: 12
                                font.bold: modelData.isCurrent
                                color: root.iceWhite
                                opacity: modelData.isCurrent ? 1.0 : 0.85
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: root.electricCyan
                    opacity: 0.4
                    Layout.topMargin: 4
                }
            }

            // ==========================================
            // 3. CLIMA (CÓRDOBA CAPITAL)
            // ==========================================
            Rectangle {
                Layout.fillWidth: true
                height: 86
                color: root.bgCard
                opacity: 0.95
                border.color: root.electricCyan
                border.width: 1
                radius: 2

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 3

                        Text {
                            text: "CÓRDOBA CAPITAL"
                            font.family: "Exo 2"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            color: root.electricCyan
                        }

                        Text {
                            text: root.weatherCondition
                            font.family: "Exo 2"
                            font.pixelSize: 12
                            color: root.iceWhite
                            opacity: 0.95
                        }

                        RowLayout {
                            spacing: 12
                            Text {
                                text: "HUM: " + root.weatherHumidity
                                font.family: "Exo 2"
                                font.pixelSize: 10
                                color: root.mutedViolet
                            }
                            Text {
                                text: "VIENTO: " + root.weatherWind
                                font.family: "Exo 2"
                                font.pixelSize: 10
                                color: root.mutedViolet
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        spacing: 2

                        Text {
                            text: root.weatherTemp
                            font.family: "Exo 2"
                            font.pixelSize: 24
                            font.weight: Font.Black
                            color: root.iceWhite
                            Layout.alignment: Qt.AlignRight
                        }

                        Image {
                            source: root.weatherIcon
                            Layout.preferredWidth: 26
                            Layout.preferredHeight: 26
                            sourceSize: Qt.size(26, 26)
                            fillMode: Image.PreserveAspectFit
                            Layout.alignment: Qt.AlignRight
                        }
                    }
                }
            }

            // ==========================================
            // 4. REPRODUCTOR COMPACTO (RESERVADO)
            // ==========================================
            Rectangle {
                Layout.fillWidth: true
                height: 72
                color: root.bgCard
                opacity: 0.95
                border.color: root.neonViolet
                border.width: 1
                radius: 2

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    RowLayout {
                        Layout.fillWidth: true
                        Image {
                            source: "file:///home/julian/cybercore-y2k1/icons/phosphor/disc-light.svg"
                            Layout.preferredWidth: 16
                            Layout.preferredHeight: 16
                            sourceSize: Qt.size(16, 16)
                        }
                        Text {
                            text: root.mediaPlaying ? "AUDIO ACTIVO // MPRIS" : "REPRODUCTOR EN ESPERA"
                            font.family: "Exo 2"
                            font.pixelSize: 10
                            font.weight: Font.Bold
                            color: root.mediaPlaying ? root.electricCyan : root.mutedViolet
                        }
                        Item { Layout.fillWidth: true }
                        Rectangle {
                            width: 6
                            height: 6
                            radius: 3
                            color: root.mediaPlaying ? root.electricCyan : root.neonViolet
                        }
                    }

                    Text {
                        text: root.mediaTitle
                        font.family: "Exo 2"
                        font.pixelSize: 12
                        font.weight: Font.Bold
                        color: root.iceWhite
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: root.mediaArtist
                        font.family: "Exo 2"
                        font.pixelSize: 10
                        color: root.mutedViolet
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
