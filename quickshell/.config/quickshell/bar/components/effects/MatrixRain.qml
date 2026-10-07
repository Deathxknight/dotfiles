import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "matrix"
    readonly property string fxName: "Matrix rain"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    visible: enabled

    readonly property string glyphs: "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎ0123456789"

    Repeater {
        model: root.enabled ? Math.round(20 * BarSettings.effectDensity) : 0

        delegate: Text {
            id: col
            required property int index
            readonly property real ch: 10 + Rng.rand(index * 17 + 4) * 4
            readonly property real vy: 80 / ((3500 + Rng.rand(index * 17 + 3) * 3000) / 1000)
            property real wait: Rng.rand(index * 17 + 5) * 1.2

            x: Rng.rand(index * 17 + 1) * root.width
            y: -height
            width: 14
            text: {
                let s = ""
                for (let i = 0; i < 8; i++) {
                    const p = Math.floor(Rng.rand(index * 17 + i + 10) * root.glyphs.length)
                    s += root.glyphs.charAt(p) + "\n"
                }
                return s
            }
            font.family: "monospace"
            font.pixelSize: ch
            color: Colors.primary
            opacity: 0.35 * root.intensity
            lineHeight: 0.85

            FrameAnimation {
                running: root.enabled
                onTriggered: {
                    const dt = Math.min(frameTime, 0.05)
                    if (col.wait > 0) { col.wait -= dt * root.speed; return }
                    col.y += col.vy * dt * root.speed
                    if (col.y > root.height) {
                        const shrunk = col.y > root.height + 30
                        col.y = shrunk ? Math.random() * root.height - col.height : -col.height
                        col.wait = shrunk ? 0 : Rng.rand(col.index * 17 + 5) * 1.2
                    }
                }
            }
        }
    }
}
