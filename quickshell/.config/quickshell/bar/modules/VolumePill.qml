import "../components"
import QtQuick
import Quickshell

Pill {
    id: root
    interactive: true
    leftCorner: 0
    leftPad: 12
    rightPad: 12

    onScrolled: (wheel) => {
        if (BarState.sink && BarState.sink.audio) {
            const d = wheel.angleDelta.y > 0 ? 0.05 : -0.05
            BarState.sink.audio.volume = Math.max(0, Math.min(1.5, BarState.vol + d))
        }
    }

    AudioSlider {
        width: 80
        height: 8
        volume: BarState.muted ? 0 : BarState.vol
        maxVolume: 1.5
        opacity: BarState.muted ? 0.4 : 1.0
        interactive: true

        onSeekRequested: (newVol) => {
            if (BarState.sink && BarState.sink.audio) {
                BarState.sink.audio.volume = newVol
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }
}
