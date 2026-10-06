import "../components"
import QtQuick
import Quickshell

Pill {
    id: root
    interactive: true
    leftPad: 12
    rightPad: 12
    visible: NotifState.count > 0 || NotifState.dnd

    signal toggleRequested()

    onActivated: (mouse) => {
        if (mouse.button === Qt.RightButton) NotifState.dnd = !NotifState.dnd
        else root.toggleRequested()
    }

    PText {
        color: NotifState.unreadShown > 0 && !NotifState.dnd ? Colors.primary_fixed_dim : Colors.secondary
        font.pixelSize: 18
        text: NotifState.dnd ? "\uf1f6" : "\uf0f3"
    }

    PText {
        visible: NotifState.unreadShown > 0 && !NotifState.dnd
        color: Colors.primary_fixed_dim
        font.pixelSize: 12
        text: NotifState.unreadShown
    }
}
