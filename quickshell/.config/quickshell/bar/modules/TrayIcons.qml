import "../components"
import "../components"
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Pill {
    id: root
    visible: SystemTray.items.values.length > 0

    property var parentPanel: null

    Repeater {
        model: SystemTray.items
        delegate: MouseArea {
            id: trayItem
            required property var modelData
            width: 18
            height: 18
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

            function openMenu() {
                const p = trayItem.mapToItem(null, 0, trayItem.height)
                const screenW = Quickshell.screens[0].width
                const popupW = 220
                let x = p.x
                if (x + popupW > screenW - 12) x = screenW - popupW - 12
                if (x < 12) x = 12

                BarState.trayMenuHandle = null
                Qt.callLater(function() {
                    trayMenu.anchorX = x
                    trayMenu.anchorY = p.y + 4
                    BarState.trayMenuHandle = trayItem.modelData.menu
                    trayMenu.visible = true
                })
            }

            onClicked: (mouse) => {
                if (mouse.button === Qt.LeftButton) {
                    if (modelData.onlyMenu && modelData.hasMenu) openMenu()
                    else modelData.activate()
                } else if (mouse.button === Qt.MiddleButton) {
                    modelData.secondaryActivate()
                } else if (modelData.hasMenu) {
                    openMenu()
                }
            }

            IconImage { anchors.fill: parent; source: trayItem.modelData.icon }
        }
    }

    TrayMenu {
        id: trayMenu
        menuHandle: BarState.trayMenuHandle
        parentWindow: root.parentPanel
    }
}
