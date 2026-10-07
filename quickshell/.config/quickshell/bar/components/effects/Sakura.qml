import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "sakura"
    readonly property string fxName: "Sakura petals"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    readonly property int count: Math.min(100, Math.round(20 * BarSettings.effectDensity))
    property var parts: []
    property bool inited: false

    opacity: enabled ? 1 : 0
    visible: opacity > 0.01
    Behavior on opacity { NumberAnimation { duration: 500 } }

    function reset(p, initial) {
        if (initial) {
            p.x = Math.random() * width
            p.y = Math.random() * height
        } else if (Math.random() < 0.5) {
            p.x = -10
            p.y = Math.random() * height
        } else {
            p.x = Math.random() * width * 0.8
            p.y = -8
        }
        p.vx = 22 + Math.random() * 34
        p.vy = 6 + Math.random() * 14
        p.ph = Math.random() * 6.28
        p.fr = 1.5 + Math.random() * 2
        p.rot = Math.random() * 360
        p.spin = (Math.random() - 0.5) * 160
        p.sz = 0.7 + Math.random() * 0.7
    }

    Component.onCompleted: {
        const a = []
        for (let i = 0; i < 100; i++) {
            const p = {}
            reset(p, true)
            a.push(p)
        }
        parts = a
    }

    FrameAnimation {
        running: root.enabled
        onTriggered: {
            const dt = Math.min(frameTime, 0.05)
            if (!root.inited && root.width > 0) {
                for (let k = 0; k < root.count; k++) root.reset(root.parts[k], true)
                root.inited = true
            }
            for (let i = 0; i < root.count; i++) {
                const it = rep.itemAt(i)
                if (!it) continue
                const p = root.parts[i]
                p.ph += dt * p.fr
                p.x += (p.vx + Math.sin(p.ph) * 14) * dt * root.speed
                p.y += (p.vy + Math.cos(p.ph * 0.8) * 6) * dt * root.speed
                p.rot += p.spin * dt
                if (p.x > root.width + 12 || p.y > root.height + 12) root.reset(p, false)
                it.x = p.x
                it.y = p.y
                it.rotation = p.rot
                it.scale = p.sz * (0.75 + 0.25 * Math.abs(Math.cos(p.ph * 0.7)))
                it.opacity = 0.85 * Math.min(1, root.intensity)
            }
        }
    }

    Repeater {
        id: rep
        model: root.count

        delegate: Rectangle {
            required property int index
            width: 7
            height: 5
            radius: 3
            color: ["#ffc2d4", "#ffadc6", "#fff0f5"][index % 3]
        }
    }
}
