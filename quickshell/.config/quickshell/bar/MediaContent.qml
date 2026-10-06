import "components"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

Rectangle {
    id: root

    color: "transparent"
    implicitWidth: 420
    implicitHeight: column.implicitHeight + 32
    topLeftRadius: 0
    topRightRadius: 0
    bottomLeftRadius: 20
    bottomRightRadius: 20
    clip: true

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 16
        spacing: 12

        Rectangle {
            id: artFrame
            Layout.alignment: Qt.AlignHCenter
            width: 240
            height: 240
            color: Colors.surface_container_lowest
            radius: 12
            clip: true

            Image {
                id: artImage
                anchors.centerIn: parent
                width: 236
                height: 236
                source: BarState.player && BarState.player.trackArtUrl ? BarState.player.trackArtUrl : ""
                sourceSize.width: 236
                sourceSize.height: 236
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                cache: true
                smooth: true
                mipmap: true
                visible: source != "" && status === Image.Ready
            }

            Text {
                anchors.centerIn: parent
                visible: !artImage.visible
                text: "\u266a"
                font.pixelSize: 48
                color: Colors.outline
            }
        }

        PText {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            color: Colors.on_surface
            font.pixelSize: 15
            wrapMode: Text.Wrap
            maximumLineCount: 2
            elide: Text.ElideRight
            text: BarState.player ? BarState.player.trackTitle : ""
        }

        PText {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
            color: Colors.on_surface_variant
            font.pixelSize: 13
            elide: Text.ElideRight
            text: BarState.player ? (BarState.player.trackArtist || "") : ""
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 16

            Pill {
                interactive: true
                leftPad: 14
                rightPad: 14
                opacity: BarState.player && BarState.player.canGoPrevious ? 1.0 : 0.4
                bgColor: Colors.primary_container
                hoverColor: Theme.pillHover
                onActivated: if (BarState.player && BarState.player.canGoPrevious) BarState.player.previous()
                PText {
                    color: Colors.on_primary_container
                    font.pixelSize: 18
                    text: "\uf048"
                }
            }

            Pill {
                interactive: true
                leftPad: 18
                rightPad: 18
                bgColor: Colors.primary
                hoverColor: Colors.primary_container
                onActivated: if (BarState.player) BarState.player.togglePlaying()
                PText {
                    color: Colors.on_primary
                    font.pixelSize: 18
                    text: BarState.player && BarState.player.isPlaying ? "\uf04c" : "\uf04b"
                }
            }

            Pill {
                interactive: true
                leftPad: 14
                rightPad: 14
                opacity: BarState.player && BarState.player.canGoNext ? 1.0 : 0.4
                bgColor: Colors.primary_container
                hoverColor: Theme.pillHover
                onActivated: if (BarState.player && BarState.player.canGoNext) BarState.player.next()
                PText {
                    color: Colors.on_primary_container
                    font.pixelSize: 18
                    text: "\uf051"
                }
            }
        }
    }
}
