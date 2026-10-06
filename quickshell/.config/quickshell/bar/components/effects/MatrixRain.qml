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
        model: root.enabled ? 20 : 0

        delegate: Text {
            required property int index
            readonly property real colX: Rng.rand(index * 17 + 1) * root.width
            readonly property real dur: (3500 + Rng.rand(index * 17 + 3) * 3000) / root.speed
            readonly property real ch: 10 + Rng.rand(index * 17 + 4) * 4

            x: colX
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

            SequentialAnimation on y {
                running: root.enabled
                loops: Animation.Infinite
                NumberAnimation {
                    from: -root.height
                    to: root.height
                    duration: dur
                    easing.type: Easing.Linear
                }
                PauseAnimation { duration: Rng.rand(index * 17 + 5) * 1200 }
            }
        }
    }
}
