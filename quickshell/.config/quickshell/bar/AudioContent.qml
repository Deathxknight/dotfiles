import "components"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire

Rectangle {
    id: root

    color: "transparent"
    implicitWidth: 260
    implicitHeight: column.implicitHeight + 12
    topLeftRadius: 0
    topRightRadius: 0
    bottomLeftRadius: 14
    bottomRightRadius: 14
    clip: true

    PwObjectTracker {
        objects: Pipewire.nodes
    }


    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 6
        spacing: 2

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 40
            radius: 12
            color: Theme.pill

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 10

                PText {
                    text: BarState.muted ? "\uf026" : (BarState.vol < 0.34 ? "\uf026" : (BarState.vol < 0.67 ? "\uf027" : "\uf028"))
                    color: BarState.muted ? Colors.outline : Colors.primary
                    font.pixelSize: 16
                }

                AudioSlider {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 8
                    volume: BarState.muted ? 0 : BarState.vol
                    maxVolume: 1.5
                    opacity: BarState.muted ? 0.4 : 1.0
                    interactive: true
                    onSeekRequested: (newVol) => {
                        if (BarState.sink && BarState.sink.audio) {
                            BarState.sink.audio.volume = newVol
                        }
                    }
                }

                PText {
                    text: BarState.muted ? "Mute" : Math.round(BarState.vol * 100) + "%"
                    color: BarState.muted ? Colors.outline : Colors.primary
                    font.pixelSize: 13
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onWheel: (wheel) => {
                    if (BarState.sink && BarState.sink.audio) {
                        const d = wheel.angleDelta.y > 0 ? 0.05 : -0.05
                        BarState.sink.audio.volume = Math.max(0, Math.min(1.5, BarState.vol + d))
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.topMargin: 4
            Layout.bottomMargin: 4
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            implicitHeight: 1
            color: Colors.outline_variant
        }

        Repeater {
            model: Pipewire.nodes.values.filter(n => n.isSink && !n.isStream && n.audio)

            delegate: Rectangle {
                id: row
                required property var modelData
                required property int index

                Layout.fillWidth: true
                implicitHeight: 36
                radius: 9
                color: {
                    if (hoverArea.containsMouse) return Theme.pillHover
                    if (Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.id === modelData.id)
                        return Theme.bar
                    return "transparent"
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    PText {
                        visible: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.id === modelData.id
                        text: "\uf00c"
                        color: Colors.primary
                        font.pixelSize: 12
                        Layout.preferredWidth: 14
                    }

                    PText {
                        Layout.fillWidth: true
                        text: modelData.description || modelData.name || "Unknown"
                        color: Colors.on_surface
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }
                }

                MouseArea {
                    id: hoverArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        Pipewire.preferredDefaultAudioSink = modelData
                    }
                }
            }
        }
    }
}
