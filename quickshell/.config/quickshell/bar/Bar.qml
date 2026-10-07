import "components"
import "modules"
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Item {
    id: root

    required property var popouts
    readonly property bool cursorInside: barHover.hovered
    readonly property real cursorX: barHover.point.position.x
    readonly property real cursorY: barHover.point.position.y

    function togglePopout(name, item) {
        if (root.popouts.currentPopout === name) {
            root.popouts.currentPopout = ""
            return
        }
        BarState.mediaPopupOpen = false
        const c = item.mapToItem(root, item.width / 2, 0)
        root.popouts.anchorX = c.x
        root.popouts.anchorY = c.y
        root.popouts.currentPopout = name
    }


    property string hoverTarget: ""

    function hoverEnterPill(name, item) {
        if (name === "settings") {
            hoverOpenTimer.stop()
            BarState.pendingPopout = ""
            return
        }
        BarState.pendingPopout = name
        const c = item.mapToItem(root, item.width / 2, 0)
        root.popouts.anchorX = c.x
        root.popouts.anchorY = c.y

        Qt.callLater(function() {
            if (root.hoverTarget === name) hoverOpenTimer.restart()
        })
    }

    function hoverLeavePill() {
        hoverOpenTimer.stop()
        hoverCloseTimer.restart()
    }

    function hitPill(item, p) {
        if (!item || !item.visible || !p) return false
        const l = item.mapFromItem(root, p.x, p.y)
        return l.x >= -2 && l.y >= 0 && l.x < item.width + 2 && l.y < item.height
    }

    function updatePillHover(p) {
        let t = ""
        let item = null
        if (hitPill(notifPill, p)) { t = "notifs"; item = notifPill }
        else if (hitPill(clipPill, p)) { t = "clip"; item = clipPill }
        else if (hitPill(volumePill, p)) { t = "audio"; item = volumePill }
        else if (hitPill(mediaPill, p)) { t = "media"; item = mediaPill }
        else if (hitPill(settingsPill, p)) { t = "settings"; item = settingsPill }
        if (t === root.hoverTarget) return
        root.hoverTarget = t
        if (t === "") root.hoverLeavePill()
        else root.hoverEnterPill(t, item)
    }

    HoverHandler {
        id: barHover
        onPointChanged: root.updatePillHover(point.position)
        onHoveredChanged: if (!hovered) root.updatePillHover(null)
    }

    IpcHandler {
        target: "clip"
        function toggle(): void { root.togglePopout("clip", clipPill) }
    }

    IpcHandler {
        target: "notifs"
        function toggle(): void { root.togglePopout("notifs", notifPill.visible ? notifPill : clipPill) }
        function dnd(): void { NotifState.dnd = !NotifState.dnd }
        function clear(): void { NotifState.clearAll() }
    }

    Timer {
        id: hoverOpenTimer
        interval: 150
        repeat: false
        onTriggered: {
            if (BarState.pendingPopout !== "" && root.popouts.currentPopout !== "settings") {
                root.popouts.currentPopout = BarState.pendingPopout
                BarState.mediaPopupOpen = (BarState.pendingPopout === "media")
            }
        }
    }

    Timer {
        id: hoverCloseTimer
        interval: root.popouts && root.popouts.currentPopout === "settings" ? 400 : 250
        repeat: false
        onTriggered: {
            const keep = ["tray"]
            const popHovered = root.popouts ? root.popouts.popoutHovered : false
            if (!popHovered && root.hoverTarget === "" && root.popouts.currentPopout !== "" && keep.indexOf(root.popouts.currentPopout) === -1) {
                root.popouts.currentPopout = ""
                BarState.mediaPopupOpen = false
            }
        }
    }


    Connections {
        target: root.popouts
        function onPopoutHoveredChanged() {
            if (root.popouts && !root.popouts.popoutHovered)
                hoverCloseTimer.restart()
        }
    }


    Row {
        anchors { left: parent.left; leftMargin: 12; verticalCenter: parent.verticalCenter }
        spacing: 12

        Workspaces {}

        MediaPill {
            id: mediaPill

            onScrolled: (wheel) => {
                if (!BarState.player) return
                if (wheel.angleDelta.y > 0) BarState.player.next()
                else BarState.player.previous()
            }
        }

        Pill {
            id: settingsPill
            interactive: true
            leftPad: 12
            rightPad: 12
            onActivated: root.togglePopout("settings", settingsPill)

            PText {
                color: Colors.secondary
                font.pixelSize: 16
                text: "\uf013"
            }
        }
    }


    Clock {
        anchors.centerIn: parent
    }


    Row {
        anchors { right: parent.right; rightMargin: 15; verticalCenter: parent.verticalCenter }
        spacing: 0

        KeyDisplay {}

        Pill {
            visible: SystemTray.items.values.length > 0
            leftPad: 12
            rightPad: 12
            Repeater {
                model: SystemTray.items
                delegate: MouseArea {
                    id: trayItem
                    required property var modelData
                    width: 18
                    height: 18
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                    function openMenu() {
                        if (root.popouts.currentPopout === "tray" && BarState.trayMenuHandle === modelData.menu) {
                            root.popouts.currentPopout = ""
                            return
                        }
                        BarState.trayMenuHandle = modelData.menu
                        BarState.mediaPopupOpen = false
                        const c = trayItem.mapToItem(root, trayItem.width / 2, 0)
                        root.popouts.anchorX = c.x
                        root.popouts.anchorY = c.y
                        if (root.popouts.currentPopout === "tray") root.popouts.relock()
                        else root.popouts.currentPopout = "tray"
                    }

                    onClicked: (mouse) => {
                        if (mouse.button === Qt.LeftButton) {
                            if (modelData.onlyMenu && modelData.hasMenu) {
                                trayItem.openMenu()
                            } else {
                                modelData.activate()
                            }
                        } else if (mouse.button === Qt.MiddleButton) {
                            modelData.secondaryActivate()
                        } else if (modelData.hasMenu) {
                            trayItem.openMenu()
                        }
                    }

                    IconImage {
                        id: trayIcon
                        anchors.fill: parent
                        source: trayItem.modelData.icon
                        visible: false
                    }

                    MultiEffect {
                        anchors.fill: trayIcon
                        source: trayIcon
                        saturation: -0.5
                        colorization: 0.6
                        colorizationColor: Colors.primary
                    }
                }
            }
        }

        NotifPill {
            id: notifPill
            onToggleRequested: root.togglePopout("notifs", notifPill)
        }

        Row {
            spacing: 0
            ClipsePill {
                id: clipPill
                onOpenRequested: root.togglePopout("clip", clipPill)
            }
            VolumePill {
                id: volumePill

            }
        }

        ProfilePill {}
    }
}
