import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.private.mpris as Mpris

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
    property string timeStr: "00:00:00"
    property string dateStr: ""
    property string calendarHeader: ""
    property var calendarCells: []
    property string lastCalendarDateKey: ""

    function updateCalendar(d) {
        var year = d.getFullYear();
        var month = d.getMonth();
        var day = d.getDate();
        var dateKey = year + "-" + (month + 1) + "-" + day;
        if (dateKey === root.lastCalendarDateKey) return;
        root.lastCalendarDateKey = dateKey;

        var months = ["ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE"];
        root.calendarHeader = months[month] + " " + year;

        var firstDay = new Date(year, month, 1).getDay();
        var daysInMonth = new Date(year, month + 1, 0).getDate();
        var cells = [];
        
        for (var i = 0; i < firstDay; i++) {
            cells.push({ day: "", isCurrent: false });
        }
        for (var n = 1; n <= daysInMonth; n++) {
            cells.push({ day: n, isCurrent: (n === day) });
        }
        root.calendarCells = cells;
    }

    // Weather Data (Córdoba Capital)
    property string weatherTemp: "--"
    property string weatherCondition: "Cargando clima..."
    property string weatherHumidity: "--%"
    property string weatherWind: "-- km/h"
    property string weatherUpdated: ""
    property string weatherIcon: "file:///home/julian/.local/share/icons/phosphor/cloud-sun-light.svg"
    property bool weatherFetching: false

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date();
            var h = String(now.getHours()).padStart(2, '0');
            var m = String(now.getMinutes()).padStart(2, '0');
            var s = String(now.getSeconds()).padStart(2, '0');
            root.timeStr = h + ":" + m + ":" + s;

            var days = ["DOMINGO", "LUNES", "MARTES", "MIÉRCOLES", "JUEVES", "VIERNES", "SÁBADO"];
            var monthsShort = ["ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"];
            var dayNum = String(now.getDate()).padStart(2, '0');
            root.dateStr = "SYS.DATE: " + dayNum + "-" + monthsShort[now.getMonth()] + " // " + days[now.getDay()];

            root.updateCalendar(now);
        }
    }

    Timer {
        interval: 900000 // 15 mins
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: fetchWeather()
    }

    Mpris.Mpris2Model {
        id: mprisModel
    }

    readonly property var activePlayer: mprisModel.currentPlayer
    property string mediaTitle: activePlayer && activePlayer.track ? activePlayer.track : "Sin reproducción activa"
    property string mediaArtist: activePlayer && activePlayer.artist ? activePlayer.artist : (activePlayer ? (activePlayer.identity || "Cybercore MPRIS") : "Módulo listo // Esperando MPRIS")
    property string mediaStatus: activePlayer ? (activePlayer.playbackStatus === Mpris.PlaybackStatus.Playing ? "Playing" : (activePlayer.playbackStatus === Mpris.PlaybackStatus.Paused ? "Paused" : "Stopped")) : "Stopped"
    property bool mediaPlaying: activePlayer ? (activePlayer.playbackStatus === Mpris.PlaybackStatus.Playing) : false

    Timer {
        id: weatherTimeoutTimer
        interval: 10000
        repeat: false
        onTriggered: {
            if (root.currentWeatherXhr) {
                var expired = root.currentWeatherXhr;
                root.currentWeatherXhr = null;
                expired.abort();
            }
            root.weatherFetching = false;
            if (root.weatherTemp === "--") {
                root.weatherCondition = "Tiempo de espera agotado";
            } else if (!root.weatherCondition.includes("[OFFLINE]")) {
                root.weatherCondition = root.weatherCondition + " [OFFLINE]";
            }
        }
    }

    property var currentWeatherXhr: null

    function fetchWeather() {
        if (root.weatherFetching) return;
        root.weatherFetching = true;
        weatherTimeoutTimer.start();

        var xhr = new XMLHttpRequest();
        root.currentWeatherXhr = xhr;
        xhr.open("GET", "https://api.open-meteo.com/v1/forecast?latitude=-31.42&longitude=-64.19&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&timezone=America%2FArgentina%2FCordoba");
        xhr.onreadystatechange = function() {
            if (root.currentWeatherXhr !== xhr) return;
            if (xhr.readyState === XMLHttpRequest.DONE) {
                weatherTimeoutTimer.stop();
                root.currentWeatherXhr = null;
                root.weatherFetching = false;
                if (xhr.status === 200) {
                    try {
                        var data = JSON.parse(xhr.responseText);
                        var cur = data && data.current;
                        var keys = ["temperature_2m", "relative_humidity_2m", "wind_speed_10m", "weather_code"];
                        if (!cur || keys.some(function(key) { return typeof cur[key] !== "number" || !isFinite(cur[key]); }) ||
                            cur.relative_humidity_2m < 0 || cur.relative_humidity_2m > 100 || cur.wind_speed_10m < 0 ||
                            cur.weather_code < 0 || cur.weather_code > 99 || Math.floor(cur.weather_code) !== cur.weather_code) {
                            throw new Error("Invalid weather payload");
                        }
                        root.weatherTemp = Math.round(cur.temperature_2m) + "°C";
                        root.weatherHumidity = cur.relative_humidity_2m + "%";
                        root.weatherWind = Math.round(cur.wind_speed_10m) + " km/h";
                        
                        var d = new Date();
                        root.weatherUpdated = String(d.getHours()).padStart(2, '0') + ":" + String(d.getMinutes()).padStart(2, '0');

                        var code = cur.weather_code;
                        var baseIcon = "file:///home/julian/.local/share/icons/phosphor/";
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
                    } catch(e) {
                        if (root.weatherTemp === "--") {
                            root.weatherCondition = "Datos inválidos";
                        } else if (!root.weatherCondition.includes("[OFFLINE]")) {
                            root.weatherCondition = root.weatherCondition + " [OFFLINE]";
                        }
                    }
                } else {
                    // Handles HTTP errors (4xx, 5xx) as well as network failures (status 0 when not aborted)
                    if (root.weatherTemp === "--") {
                        root.weatherCondition = (xhr.status === 0 ? "Sin conexión" : "Error al actualizar");
                    } else if (!root.weatherCondition.includes("[OFFLINE]")) {
                        root.weatherCondition = root.weatherCondition + " [OFFLINE]";
                    }
                }
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
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: clockCol.implicitHeight + 20
                color: root.bgCard
                opacity: 0.88
                border.color: root.electricCyan
                border.width: 1
                radius: 4

                ColumnLayout {
                    id: clockCol
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    Text {
                        text: "[ " + root.timeStr + " ]"
                        font.family: "Share Tech Mono"
                        font.pixelSize: 42
                        font.bold: true
                        color: root.iceWhite
                        Layout.alignment: Qt.AlignRight
                    }

                    Text {
                        text: root.dateStr
                        font.family: "Share Tech Mono"
                        font.pixelSize: 13
                        font.bold: true
                        color: root.electricCyan
                        Layout.alignment: Qt.AlignRight
                    }
                }
            }

            // ==========================================
            // 2. CALENDARIO MINIMALISTA
            // ==========================================
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: calCol.implicitHeight + 20
                color: root.bgCard
                opacity: 0.88
                border.color: root.neonViolet
                border.width: 1
                radius: 4

                ColumnLayout {
                    id: calCol
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 12

                    // Mes / Año
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: root.calendarHeader
                            font.family: "Exo 2"
                            font.pixelSize: 14
                            font.bold: true
                            color: root.electricCyan
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: "CYBERCORE CAL"
                            font.family: "Exo 2"
                            font.pixelSize: 10
                            font.bold: true
                            color: root.iceWhite
                            opacity: 0.9
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
                                color: root.electricCyan
                                opacity: 0.95
                                horizontalAlignment: Text.AlignHCenter
                                Layout.fillWidth: true
                            }
                        }

                        // Celdas del mes
                        Repeater {
                            model: root.calendarCells

                            Rectangle {
                                Layout.preferredWidth: 32
                                Layout.preferredHeight: 28
                                Layout.alignment: Qt.AlignCenter
                                color: modelData.isCurrent ? root.neonViolet : (modelData.day !== "" ? "#15051A66" : "transparent")
                                border.color: modelData.isCurrent ? root.electricCyan : "transparent"
                                border.width: modelData.isCurrent ? 1 : 0
                                radius: 2

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.day
                                    font.family: "Exo 2"
                                    font.pixelSize: 12
                                    font.bold: modelData.isCurrent
                                    color: root.iceWhite
                                    opacity: modelData.isCurrent ? 1.0 : 0.95
                                }
                            }
                        }
                    }
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
                            text: root.weatherCondition + (root.weatherUpdated !== "" ? " (" + root.weatherUpdated + ")" : "")
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
                            source: "file:///home/julian/.local/share/icons/phosphor/disc-light.svg"
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

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.activePlayer && typeof root.activePlayer.PlayPause === "function") {
                            root.activePlayer.PlayPause();
                        }
                    }
                }
            }
        }
    }
}

