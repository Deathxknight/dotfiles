import "components"
import "modules"
import QtQuick
import Quickshell
import Quickshell.Hyprland

ShellRoot {
    NotifToasts {}

    AudioAnalyzer {
        id: audio
        needed: BarSettings.effectEnabled("beat") || BarSettings.effectEnabled("confetti")
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel
            required property var modelData
            screen: modelData

            anchors { top: true; left: true; right: true }
            margins.top: 13
            margins.left: 8
            margins.right: 8
            implicitHeight: 520
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: 40
            color: "transparent"

            mask: Region {
                x: 0
                y: 0
                width: panel.width
                height: {
                    if (popoutsLoader.item && popoutsLoader.item.popupHeight > 0)
                        return 40 + popoutsLoader.item.popupHeight + 10;
                    return 40;
                }
            }


            HoverHandler { id: panelHover }

            HyprlandFocusGrab {
                active: !!(popoutsLoader.item && (popoutsLoader.item.currentPopout === "tray" || popoutsLoader.item.sticky))
                windows: [panel]
                onCleared: {
                    if (popoutsLoader.item) popoutsLoader.item.currentPopout = ""
                }
            }

            BlobBackground {
                id: blobBg
                anchors.fill: parent
                barHeight: 40
                barRadius: 20
                popupRadius: 24
                blobSmoothing: 48
                mergeOverlap: popoutsLoader.item ? popoutsLoader.item.overlap : 0
                blobColor: Theme.bar
                opacity: BarSettings.transparent ? BarSettings.barOpacity : 1.0

                popupCenterX: popoutsLoader.item ? popoutsLoader.item.popupCenterX : 0
                popupWidth: popoutsLoader.item ? popoutsLoader.item.popupWidth : 0
                popupFullHeight: popoutsLoader.item ? popoutsLoader.item.animHeight : 0
                popupScale: popoutsLoader.item ? popoutsLoader.item.offsetScale : 1
            }

            BlobBackground {
                id: blobMask
                anchors.fill: parent
                visible: false
                layer.enabled: BarState.popupEffects
                barHeight: 40
                barRadius: 20
                popupRadius: 24
                blobSmoothing: 48
                blobColor: "white"
                opacity: 1.0

                mergeOverlap: popoutsLoader.item ? popoutsLoader.item.overlap : 0
                popupCenterX: popoutsLoader.item ? popoutsLoader.item.popupCenterX : 0
                popupWidth: popoutsLoader.item ? popoutsLoader.item.popupWidth : 0
                popupFullHeight: popoutsLoader.item ? popoutsLoader.item.animHeight : 0
                popupScale: popoutsLoader.item ? popoutsLoader.item.offsetScale : 1
            }

            Effects {
                id: effectsLayer
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: BarState.popupEffects ? parent.height : 40
                customMask: BarState.popupEffects ? blobMask : null
                contentHeight: (BarState.popupEffects && popoutsLoader.item) ? 40 + popoutsLoader.item.popupHeight : 40
                radius: 20

                barMouseX: panelHover.hovered ? panelHover.point.position.x : -300
                barMouseY: panelHover.hovered ? panelHover.point.position.y : -300

                audioLevel: audio.level
                bass: audio.bass
                beatTick: audio.beatTick
                beatStrength: audio.beatStrength
            }

            Item {
                id: barHost
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 40

                Bar {
                    id: barItem
                    anchors.fill: parent
                    popouts: popoutsLoader.item
                }
            }

            Loader {
                id: popoutsLoader
                anchors.top: barHost.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 480
                active: true
                sourceComponent: Popouts { deformMatrix: blobBg.popupBody.deformMatrix }
            }
        }
    }
}
