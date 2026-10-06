import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "blobs"
    readonly property string fxName: "Drifting blobs"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20
    property real audioLevel: 0

    property real t: 0

    opacity: enabled ? 1 : 0
    visible: opacity > 0.01
    Behavior on opacity { NumberAnimation { duration: 600 } }

    FrameAnimation {
        running: root.enabled
        onTriggered: root.t += Math.min(frameTime, 0.05) * root.speed
    }

    Repeater {
        model: 3

        delegate: Canvas {
            required property int index

            width: 220
            height: 220
            property color tint: [Colors.primary, Colors.secondary, Colors.tertiary][index]
            onTintChanged: requestPaint()

            x: root.width * (0.5 + 0.42 * Math.sin(root.t * (0.22 + index * 0.09) + index * 2.1)) - width / 2
            y: root.height / 2 - height / 2 + 6 * Math.sin(root.t * 0.5 + index)
            scale: 0.9 + 0.25 * Math.sin(root.t * 0.4 + index * 1.7) + root.audioLevel * 0.5
            opacity: Math.min(1, 0.28 * root.intensity)

            onPaint: {
                const ctx = getContext("2d")
                ctx.reset()
                const c = tint
                const g = ctx.createRadialGradient(width / 2, height / 2, 0, width / 2, height / 2, width / 2)
                g.addColorStop(0.0, Qt.rgba(c.r, c.g, c.b, 0.9))
                g.addColorStop(0.5, Qt.rgba(c.r, c.g, c.b, 0.35))
                g.addColorStop(1.0, Qt.rgba(c.r, c.g, c.b, 0.0))
                ctx.fillStyle = g
                ctx.fillRect(0, 0, width, height)
            }
        }
    }
}
