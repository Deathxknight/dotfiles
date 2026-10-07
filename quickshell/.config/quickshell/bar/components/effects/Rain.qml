import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "rain"
    readonly property string fxName: "Rain"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    visible: enabled

    Repeater {
        model: root.enabled ? Math.round(22 * BarSettings.effectDensity) : 0

        delegate: Item {
            id: drop
            required property int index
            readonly property real len: 8 + Rng.rand(index * 3 + 1) * 10
            // px/s: the original fall (40px bar) over its original duration
            readonly property real vy: (40 + 2 * len) / ((900 + Rng.rand(index * 3 + 3) * 900) / 1000)
            property real wait: Rng.rand(index * 3 + 4) * 0.6

            x: Rng.rand(index * 3 + 2) * root.width
            y: -len
            width: 1
            height: len

            Rectangle {
                anchors.fill: parent
                color: Colors.secondary
                opacity: 0.35 * root.intensity
            }

            FrameAnimation {
                running: root.enabled
                onTriggered: {
                    const dt = Math.min(frameTime, 0.05)
                    if (drop.wait > 0) { drop.wait -= dt * root.speed; return }
                    drop.y += drop.vy * dt * root.speed
                    if (drop.y > root.height + drop.len) {
                        const shrunk = drop.y > root.height + drop.len + 30
                        drop.y = shrunk ? Math.random() * root.height - drop.len : -drop.len
                        drop.wait = shrunk ? 0 : Rng.rand(drop.index * 3 + 4) * 0.6
                    }
                }
            }
        }
    }
}
