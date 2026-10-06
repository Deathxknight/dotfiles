import "../components"
import QtQuick
import Quickshell

Pill {
    id: root
    interactive: true
    leftPad: 18
    rightPad: 18
    visible: BarState.player !== null
    flattenBottom: BarState.mediaPopupOpen
    bgColor: BarState.mediaPopupOpen ? Theme.bar : Theme.pill

    onActivated: (mouse) => {
        if (mouse.button === Qt.RightButton && BarState.player) BarState.player.togglePlaying()
    }

    Item {
        width: 320
        height: 20

        PText {
            anchors.fill: parent
            elide: Text.ElideRight
            clip: true
            color: Colors.secondary
            verticalAlignment: Text.AlignVCenter
            text: BarState.player
                ? ((BarState.player.trackArtist ? BarState.player.trackArtist + " - " : "") + BarState.player.trackTitle)
                : ""
        }
    }
}
