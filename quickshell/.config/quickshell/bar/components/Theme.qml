pragma Singleton
import QtQuick
import Quickshell



Singleton {
    id: root


    property real barLift: 0.0       // raise if the bar is too dark (try 0.08)
    property real containerMix: 0.08 // rows, track backgrounds
    property real pillMix: 0.14      // pill backgrounds
    property real hoverMix: 0.26     // hovered/pressed pills and rows

    function mix(a, b, t) {
        return Qt.rgba(a.r + (b.r - a.r) * t,
                       a.g + (b.g - a.g) * t,
                       a.b + (b.b - a.b) * t, 1)
    }

    readonly property color bar:       mix(Colors.on_primary_fixed, Colors.primary, barLift)
    readonly property color container: mix(bar, Colors.primary, containerMix)
    readonly property color pill:      mix(bar, Colors.primary, pillMix)
    readonly property color pillHover: mix(bar, Colors.primary, hoverMix)
}
