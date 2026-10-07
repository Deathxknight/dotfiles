import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "bubbles"
    readonly property string fxName: "Bubbles"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    visible: enabled

    Repeater {
        model: root.enabled ? Math.round(18 * BarSettings.effectDensity) : 0

        delegate: Rectangle {
            id: bub
            required property int index
            readonly property real size: 3 + Rng.rand(index * 13 + 1) * 8
            readonly property real vy: (40 + 2 * size) / ((6000 + Rng.rand(index * 13 + 3) * 5000) / 1000)

            property real py: root.height + size
            property real wait: Rng.rand(index * 13 + 4) * 0.8
            // 0 at the bottom, 1 at the top of the current visible height
            readonly property real prog: (root.height + size - py) / (root.height + 2 * size)

            x: Rng.rand(index * 13 + 2) * root.width
            y: py
            width: size
            height: size
            radius: size / 2
            color: Colors.secondary
            border.width: 1
            border.color: Colors.on_surface
            opacity: 0.35 * root.intensity * Math.max(0, Math.min(1, prog / 0.15, (1 - prog) / 0.15))

            FrameAnimation {
                running: root.enabled
                onTriggered: {
                    const dt = Math.min(frameTime, 0.05)
                    if (bub.wait > 0) {
                        bub.wait -= dt * root.speed
                        bub.py = root.height + bub.size
                        return
                    }
                    bub.py -= bub.vy * dt * root.speed
                    if (bub.py < -bub.size) {
                        bub.py = root.height + bub.size
                        bub.wait = Rng.rand(bub.index * 13 + 4) * 0.8
                    } else if (bub.py > root.height + bub.size) {
                        bub.py = root.height + bub.size
                    }
                }
            }
        }
    }
}
