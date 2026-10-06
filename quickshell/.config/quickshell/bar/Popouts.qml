import "components"
import QtQuick
import Quickshell

Item {
    id: root

    property string currentPopout: ""
    property real anchorX: 0
    property real anchorY: 0

    property bool hasCurrent: false
    property string shownName: ""
    property real lockedAnchorX: 0
    property real trayHeight: 200

    property matrix4x4 deformMatrix


    readonly property bool popoutHovered: popHover.hovered


    function clampX(x) {
        return Math.max(targetWidth / 2 + 8, Math.min(width - targetWidth / 2 - 8, x))
    }
    function relock() { lockedAnchorX = clampX(anchorX) }

    onCurrentPopoutChanged: {
        if (currentPopout !== "") {
            shownName = currentPopout
            lockedAnchorX = clampX(anchorX)
            hasCurrent = true
        } else {
            hasCurrent = false
        }
    }

    property real offsetScale: hasCurrent ? 0 : 1
    Behavior on offsetScale { Anim {} }

    readonly property real targetWidth: {
        if (shownName === "media") return 420
        if (shownName === "audio") return 260
        if (shownName === "tray") return 240
        if (shownName === "clip") return 380
        if (shownName === "notifs") return 380
        if (shownName === "settings") return 320
        return 0
    }
    readonly property real targetHeight: {
        if (shownName === "media") return 420
        if (shownName === "audio") return 480
        if (shownName === "tray") return trayHeight
        if (shownName === "clip") return 460
        if (shownName === "notifs") return 460
        if (shownName === "settings") return 430
        return 0
    }

    property real animWidth: targetWidth
    property real animHeight: targetHeight
    property real animCenterX: lockedAnchorX
    Behavior on animWidth   { enabled: root.offsetScale < 1; Anim {} }
    Behavior on animHeight  { enabled: root.offsetScale < 1; Anim {} }
    Behavior on animCenterX { enabled: root.offsetScale < 1; Anim {} }

    readonly property real overlap: animHeight * 0.2

    readonly property real popupHeight: Math.max(0, animHeight * (1 - offsetScale))
    readonly property real popupWidth: (hasCurrent || popupHeight > 1) ? animWidth : 0
    readonly property real popupCenterX: animCenterX

    clip: true

    Item {
        id: slot
        x: root.animCenterX - width / 2
        width: root.animWidth
        height: root.animHeight + root.overlap
        y: -root.overlap - (root.animHeight + 5) * root.offsetScale
        transform: Matrix4x4 { matrix: root.deformMatrix }

        HoverHandler {
            id: popHover
            enabled: root.hasCurrent
        }

        Popout {
            name: "media"
            width: 420; height: 420
            sourceComponent: MediaContent {}
        }

        Popout {
            name: "audio"
            width: 260; height: 480
            sourceComponent: AudioContent {}
        }

        Popout {
            name: "tray"
            width: 240; height: root.trayHeight
            sourceComponent: TrayMenuContent {
                menu: BarState.trayMenuHandle
                onWantedHeightChanged: root.trayHeight = Math.min(480, wantedHeight)
                onCloseRequested: root.currentPopout = ""
                Component.onCompleted: root.trayHeight = Math.min(480, wantedHeight)
            }
        }

        Popout {
            name: "clip"
            width: 380; height: 460
            sourceComponent: ClipContent {
                onCloseRequested: root.currentPopout = ""
            }
        }

        Popout {
            name: "notifs"
            width: 380; height: 460
            sourceComponent: NotifContent {}
        }

        Popout {
            name: "settings"
            width: 320; height: 430
            sourceComponent: SettingsContent {}
        }
    }

    component Popout: Loader {
        id: popout
        required property string name
        readonly property bool shouldBeActive: root.hasCurrent && root.currentPopout === name

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: root.overlap
        active: false
        opacity: 0

        states: State {
            name: "active"
            when: popout.shouldBeActive
            PropertyChanges {
                popout.active: true
                popout.opacity: 1
            }
        }

        transitions: [
            Transition {
                from: ""; to: "active"
                SequentialAnimation {
                    PropertyAction { property: "active" }
                    EffectAnim { property: "opacity"; duration: 300 }
                }
            },
            Transition {
                from: "active"; to: ""
                SequentialAnimation {
                    EffectAnim { property: "opacity" }
                    PropertyAction { property: "active" }
                }
            }
        ]
    }
}
