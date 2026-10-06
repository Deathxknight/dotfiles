import "components"
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    color: "transparent"
    implicitWidth: 320
    implicitHeight: 430
    topLeftRadius: 0
    topRightRadius: 0
    bottomLeftRadius: 20
    bottomRightRadius: 20
    clip: true

    readonly property var fxList: [
        { id: "aurora",    name: "Aurora" },
        { id: "rain",      name: "Rain" },
        { id: "snow",      name: "Snow" },
        { id: "fireflies", name: "Fireflies" },
        { id: "scanlines", name: "Scanlines" },
        { id: "bubbles",   name: "Bubbles" },
        { id: "shimmer",   name: "Heat shimmer" },
        { id: "matrix",    name: "Matrix rain" },
        { id: "beat",      name: "Beat pulse" },
        { id: "mouseglow", name: "Mouse glow" },
        { id: "sparkles",  name: "Cursor sparkles" },
        { id: "confetti",  name: "Confetti burst" },
        { id: "gif",  name: "GIF overlay" },
        { id: "shine",  name: "Shine sweep" },
        { id: "stars",  name: "Starfield" },
        { id: "sakura",  name: "Sakura petals" },
        { id: "neon",  name: "Neon edge" },
        { id: "ripples",  name: "Hover ripples" },
        { id: "blobs",  name: "Drifting blobs" },
    ]

    component Check: Rectangle {
        id: chk
        property string label: ""
        property bool checked: false
        signal toggled()

        implicitHeight: 30
        Layout.preferredHeight: 30
        radius: 15
        color: ma.containsMouse ? Theme.pillHover : Theme.pill

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 8

            PText {
                text: chk.checked ? "\uf14a" : "\uf096"
                color: chk.checked ? Colors.primary : Colors.outline
                font.pixelSize: 15
            }
            PText {
                Layout.fillWidth: true
                text: chk.label
                color: Colors.on_surface
                font.pixelSize: 12
                elide: Text.ElideRight
            }
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            onClicked: chk.toggled()
        }
    }

    component SliderRow: ColumnLayout {
        id: sr
        property string label: ""
        property string readout: ""
        property real value: 0
        signal moved(real v)
        spacing: 4
        opacity: enabled ? 1.0 : 0.4

        RowLayout {
            Layout.fillWidth: true
            PText {
                Layout.fillWidth: true
                text: sr.label
                color: Colors.on_surface_variant
                font.pixelSize: 12
            }
            PText { text: sr.readout; color: Colors.primary; font.pixelSize: 12 }
        }

        AudioSlider {
            Layout.fillWidth: true
            Layout.preferredHeight: 8
            volume: sr.value
            maxVolume: 1
            interactive: sr.enabled
            onSeekRequested: (v) => sr.moved(v)
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: col.implicitHeight + 32
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {
            id: col
            x: 16; y: 16
            width: root.width - 32
            spacing: 10

            PText {
                text: "Appearance"
                color: Colors.on_surface
                font.pixelSize: 15
                font.bold: true
            }

            PText { text: "COLOUR SCHEME"; color: Colors.outline; font.pixelSize: 10 }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 6
                rowSpacing: 6

                Repeater {
                    model: Palettes.list

                    delegate: Check {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        label: modelData.name
                        checked: BarSettings.scheme === modelData.id
                        onToggled: BarSettings.scheme = modelData.id
                    }
                }
            }

            PText { text: "EFFECTS"; color: Colors.outline; font.pixelSize: 10 }

            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 6
                rowSpacing: 6
                visible: root.fxList.length > 0

                Repeater {
                    model: root.fxList

                    delegate: Check {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        label: modelData.name
                        checked: BarSettings.effectEnabled(modelData.id)
                        onToggled: BarSettings.setEffect(modelData.id, !BarSettings.effectEnabled(modelData.id))
                    }
                }
            }

            PText {
                visible: root.fxList.length === 0
                text: "No effects installed.\nDrop .qml files into components/effects/."
                color: Colors.outline
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Check {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                label: "Transparent bar"
                checked: BarSettings.transparent
                onToggled: BarSettings.transparent = !BarSettings.transparent
            }

            SliderRow {
                Layout.fillWidth: true
                label: "Saturation"
                readout: Math.round(BarSettings.saturation * 100) + "%"
                value: BarSettings.saturation / 2
                onMoved: (v) => BarSettings.saturation = Math.max(0, Math.min(2, v * 2))
            }
            SliderRow {
                Layout.fillWidth: true
                enabled: BarSettings.transparent
                label: "Bar opacity"
                readout: Math.round(BarSettings.barOpacity * 100) + "%"
                value: BarSettings.barOpacity
                onMoved: (v) => BarSettings.barOpacity = Math.max(0.15, Math.min(1, v))
            }
            SliderRow {
                Layout.fillWidth: true
                label: "Effect intensity"
                readout: Math.round(BarSettings.effectIntensity * 100) + "%"
                value: BarSettings.effectIntensity / 2
                onMoved: (v) => BarSettings.effectIntensity = Math.max(0, Math.min(2, v * 2))
            }
            SliderRow {
                Layout.fillWidth: true
                label: "Effect speed"
                readout: Math.round(BarSettings.effectSpeed * 100) + "%"
                value: (BarSettings.effectSpeed - 0.25) / 2.75
                onMoved: (v) => BarSettings.effectSpeed = Math.max(0.25, Math.min(3, 0.25 + v * 2.75))
            }
        }
    }
}
