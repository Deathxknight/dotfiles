import "../.."
import "../../components"
import QtQuick

Item {
    id: root

    readonly property string fxId: "sparkles"
    readonly property string fxName: "Cursor sparkles"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    property real barMouseX: -300
    property real barMouseY: -300

    readonly property int poolSize: 72
    property var parts: []
    property real lastX: -999
    property real lastY: -999

    visible: enabled

    Component.onCompleted: {
        const a = []
        for (let i = 0; i < poolSize; i++)
            a.push({ x: 0, y: 0, vx: 0, vy: 0, life: 0, spin: 0 })
        parts = a
    }

    function spawn(x, y) {
        for (let i = 0; i < poolSize; i++) {
            const p = parts[i]
            if (p.life > 0) continue
            p.x = x + (Math.random() - 0.5) * 6
            p.y = y + (Math.random() - 0.5) * 6
            p.vx = (Math.random() - 0.5) * 70
            p.vy = (Math.random() - 0.7) * 50
            p.spin = (Math.random() - 0.5) * 540
            p.life = 0.6 + Math.random() * 0.6
            return
        }
    }

    FrameAnimation {
        running: root.enabled
        onTriggered: {
            const dt = Math.min(frameTime, 0.05)
            const mx = root.barMouseX, my = root.barMouseY

            if (mx >= 0 && my >= 0) {
                if (root.lastX > -900) {
                    const dx = mx - root.lastX, dy = my - root.lastY
                    const dist = Math.sqrt(dx * dx + dy * dy)
                    if (dist > 1.5) {
                        const n = Math.min(4, 1 + Math.floor(dist / 6))
                        for (let k = 0; k < n; k++) {
                            const t = (k + 1) / n
                            root.spawn(root.lastX + dx * t, root.lastY + dy * t)
                        }
                    }
                }
                root.lastX = mx
                root.lastY = my
            } else {
                root.lastX = -999
                root.lastY = -999
            }

            for (let i = 0; i < root.poolSize; i++) {
                const it = rep.itemAt(i)
                if (!it) continue
                const p = root.parts[i]
                if (p.life <= 0) { it.visible = false; continue }

                p.life -= dt * 1.4 * root.speed
                p.vy += 90 * dt
                p.x += p.vx * dt * root.speed
                p.y += p.vy * dt * root.speed

                if (p.life <= 0) { it.visible = false; continue }
                it.visible = true
                it.x = p.x - it.width / 2
                it.y = p.y - it.height / 2
                it.rotation += p.spin * dt
                it.scale = 0.4 + Math.min(1, p.life * 1.5) * 0.9
                it.opacity = Math.min(1, p.life * 2) * root.intensity
            }
        }
    }

    Repeater {
        id: rep
        model: root.poolSize

        delegate: Rectangle {
            required property int index
            width: 4
            height: 4
            radius: 1
            rotation: 45
            visible: false
            color: index % 2 === 0 ? Colors.tertiary : Colors.primary

            Rectangle {
                anchors.centerIn: parent
                width: 12
                height: 12
                radius: 6
                color: parent.color
                opacity: 0.22
            }
        }
    }
}
