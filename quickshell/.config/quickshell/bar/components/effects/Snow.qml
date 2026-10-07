import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "snow"
    readonly property string fxName: "Snow"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    visible: enabled

    Repeater {
        model: root.enabled ? Math.round(34 * BarSettings.effectDensity) : 0

        delegate: Rectangle {
            id: flake
            required property int index
            readonly property real size: 1.2 + Rng.rand(index * 9 + 1) * 2.0
            readonly property real baseX: Rng.rand(index * 9 + 2) * root.width
            readonly property real sway: 3 + Rng.rand(index * 9 + 4) * 5
            readonly property real vy: (40 + 2 * size) / ((4200 + Rng.rand(index * 9 + 3) * 4800) / 1000)

            property real py: -size
            property real wait: Rng.rand(index * 9 + 5) * 1.4

            width: size
            height: size
            radius: size / 2
            color: Colors.on_surface
            opacity: 0.6 * root.intensity
            x: baseX + Math.sin(py / 12) * sway
            y: py

            FrameAnimation {
                running: root.enabled
                onTriggered: {
                    const dt = Math.min(frameTime, 0.05)
                    if (flake.wait > 0) { flake.wait -= dt * root.speed; return }
                    flake.py += flake.vy * dt * root.speed
                    if (flake.py > root.height + flake.size) {
                        const shrunk = flake.py > root.height + flake.size + 30
                        flake.py = shrunk ? Math.random() * root.height - flake.size : -flake.size
                        flake.wait = shrunk ? 0 : Rng.rand(flake.index * 9 + 5) * 1.4
                    }
                }
            }
        }
    }
}
