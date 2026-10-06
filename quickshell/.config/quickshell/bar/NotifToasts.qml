import "components"
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Services.Notifications

PanelWindow {
    id: win

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "qs-toasts"

    anchors { top: true; right: true }
    margins.top: 63
    margins.right: 8
    implicitWidth: 360
    implicitHeight: Math.max(1, stack.implicitHeight)
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    visible: NotifState.popups.length > 0

    Column {
        id: stack
        width: win.implicitWidth

        Repeater {
            model: NotifState.items

            delegate: Item {
                id: toast

                required property var modelData

                readonly property bool critical: modelData.urgency === NotificationUrgency.Critical
                readonly property bool open: NotifState.popups.indexOf(modelData.id) !== -1
                                             && (!NotifState.dnd || critical)
                readonly property string iconSrc: {
                    const m = modelData
                    if (m.image !== "") return m.image
                    if (m.appIcon === "") return ""
                    if (m.appIcon.startsWith("/")) return "file://" + m.appIcon
                    return Quickshell.iconPath(m.appIcon, true)
                }

                width: stack.width
                height: open ? card.height + 8 : 0
                clip: true

                Behavior on height { Anim {} }

                Timer {
                    interval: {
                        const t = toast.modelData.expireTimeout
                        return (t > 0 ? Math.min(t, 10) : 6) * 1000
                    }
                    running: toast.open && !toast.critical && !hover.containsMouse
                    onTriggered: NotifState.hidePopup(toast.modelData.id)
                }

                Rectangle {
                    id: card
                    x: toast.open ? 0 : 40
                    width: toast.width
                    height: row.implicitHeight + 28
                    radius: 22
                    color: Theme.bar
                    border.width: toast.critical ? 2 : 0
                    border.color: Colors.error
                    opacity: toast.open ? 1 : 0

                    Behavior on x { Anim {} }
                    Behavior on opacity { Anim {} }

                    Row {
                        id: row
                        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 14 }
                        spacing: 12

                        IconImage {
                            id: icon
                            width: 40
                            height: 40
                            source: toast.iconSrc
                            visible: toast.iconSrc !== ""
                        }

                        Column {
                            width: row.width - (icon.visible ? icon.width + row.spacing : 0)
                            spacing: 2

                            PText {
                                width: parent.width
                                text: toast.modelData.appName
                                font.pixelSize: 11
                                color: Colors.outline
                                elide: Text.ElideRight
                                visible: text !== ""
                            }
                            PText {
                                width: parent.width
                                text: toast.modelData.summary
                                font.pixelSize: 15
                                font.bold: true
                                elide: Text.ElideRight
                            }
                            PText {
                                width: parent.width
                                text: toast.modelData.body
                                font.pixelSize: 13
                                color: Colors.outline
                                wrapMode: Text.WordWrap
                                maximumLineCount: 3
                                elide: Text.ElideRight
                                textFormat: Text.StyledText
                                visible: text !== ""
                            }
                        }
                    }

                    MouseArea {
                        id: hover
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse) => {
                            if (mouse.button === Qt.RightButton) {
                                NotifState.hidePopup(toast.modelData.id)
                                toast.modelData.dismiss()
                                return
                            }
                            const a = toast.modelData.actions
                            for (let i = 0; i < a.length; i++) {
                                if (a[i].identifier === "default") { a[i].invoke(); break }
                            }
                            NotifState.hidePopup(toast.modelData.id)
                        }
                    }
                }
            }
        }
    }
}
