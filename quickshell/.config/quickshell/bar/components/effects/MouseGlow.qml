import "../.."
import "../../components"
import QtQuick

Item {
    id: root

    readonly property string fxId: "mouseglow"
    readonly property string fxName: "Mouse glow"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    property real barMouseX: -300
    property real barMouseY: -300
    property real audioLevel: 0

    readonly property bool hot: barMouseX >= 0 && barMouseY >= 0

    property real gx: 0
    property real gy: 20
    property bool snap: false
    property bool wasHot: false

    function track() {
        if (barMouseX < 0 || barMouseY < 0) { wasHot = false; return }
        snap = !wasHot
        gx = barMouseX
        gy = barMouseY
        snap = false
        wasHot = true
    }
    onBarMouseXChanged: track()
    onBarMouseYChanged: track()

    visible: enabled

    Canvas {
        id: glow
        width: 240
        height: 240
        x: root.gx - width / 2
        y: root.gy - height / 2

        property color tint: Colors.primary
        onTintChanged: requestPaint()

        scale: 0.85 + root.audioLevel * 0.45
        opacity: root.hot ? Math.min(1, 0.55 * root.intensity + root.audioLevel * 0.3) : 0

        Behavior on x { enabled: !root.snap; SpringAnimation { spring: 3.5; damping: 0.35 } }
        Behavior on y { enabled: !root.snap; SpringAnimation { spring: 3.5; damping: 0.35 } }
        Behavior on scale { NumberAnimation { duration: 70 } }
        Behavior on opacity { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()
            const c = tint
            const g = ctx.createRadialGradient(width / 2, height / 2, 0, width / 2, height / 2, width / 2)
            g.addColorStop(0.0, Qt.rgba(c.r, c.g, c.b, 0.85))
            g.addColorStop(0.35, Qt.rgba(c.r, c.g, c.b, 0.30))
            g.addColorStop(1.0, Qt.rgba(c.r, c.g, c.b, 0.0))
            ctx.fillStyle = g
            ctx.fillRect(0, 0, width, height)
        }
    }
}
