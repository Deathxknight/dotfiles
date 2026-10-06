import "../components"
import QtQuick
import Quickshell

Pill {
    id: root
    interactive: true
    leftPad: 12
    rightPad: 12
    rightCorner: 0

    signal openRequested()

    onActivated: (mouse) => {
        if (mouse.button === Qt.RightButton) Quickshell.execDetached(["clipse", "-clear"])
        else root.openRequested()
    }

    PText {
        color: Colors.secondary
        font.pixelSize: 18
        text: "\uf07f"
    }
}
