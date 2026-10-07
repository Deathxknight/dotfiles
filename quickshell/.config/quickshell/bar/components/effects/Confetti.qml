import "../.."
import "../../components"
import QtQuick

Item {
    id: root

    readonly property string fxId: "confetti"
    readonly property string fxName: "Confetti burst"
    property bool fxDefault: true

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    property int  beatTick: 0
    property real beatStrength: 0
    property bool reactToBeat: true
    property real _lastBurst: 0

    readonly property int poolSize: 100
    property var parts: []

    visible: enabled

    Component.onCompleted: {
        const a = []
        for (let i = 0; i < poolSize; i++)
            a.push({ x: 0, y: 0, vx: 0, vy: 0, life: 0, decay: 1, phase: 0, spin: 0, ci: 0 })
        parts = a
    }

    function burst(amount) {
        if (!enabled) return
        let n = Math.round((amount || 28) * Math.max(0.5, intensity))
        for (let i = 0; i < poolSize && n > 0; i++) {
            const p = parts[i]
            if (p.life > 0) continue
            const dir = Math.random() < 0.5 ? -1 : 1
            p.x = width * (0.35 + Math.random() * 0.3)
            p.y = Math.min(height, 40) * (0.3 + Math.random() * 0.4)
            p.vx = dir * (80 + Math.random() * 320)
            p.vy = -10 - Math.random() * 60
            p.life = 1.0
            p.decay = 0.7 + Math.random() * 0.6
            p.phase = Math.random() * 6.28
            p.spin = (Math.random() - 0.5) * 720
            p.ci = Math.floor(Math.random() * 4)
            n--
        }
    }

    onBeatTickChanged: {
        if (!reactToBeat || !enabled) return
        const now = Date.now()
        if (beatStrength > 0.6 && now - _lastBurst > 1200) {
            _lastBurst = now
            burst(16 + Math.round(beatStrength * 20))
        }
    }

    Connections {
        target: BarSettings
        ignoreUnknownSignals: true
        function onConfettiRequested() { root.burst(36) }
    }

    FrameAnimation {
        running: root.enabled
        onTriggered: {
            const dt = Math.min(frameTime, 0.05)
            for (let i = 0; i < root.poolSize; i++) {
                const it = rep.itemAt(i)
                if (!it) continue
                const p = root.parts[i]
                if (p.life <= 0) { it.visible = false; continue }

                p.life -= dt * p.decay * root.speed
                p.vx *= (1 - 1.8 * dt)
                p.vy += 140 * dt
                p.phase += dt * 9
                p.x += (p.vx + Math.sin(p.phase) * 25) * dt * root.speed
                p.y += p.vy * dt * root.speed

                if (p.life <= 0) { it.visible = false; continue }
                it.visible = true
                it.x = p.x
                it.y = p.y
                it.rotation += p.spin * dt
                it.opacity = Math.min(1, p.life * 3) * root.intensity
                it.scale = 0.6 + 0.4 * Math.abs(Math.cos(p.phase * 0.8))
                it.palIndex = p.ci
            }
        }
    }

    Repeater {
        id: rep
        model: root.poolSize

        delegate: Rectangle {
            property int palIndex: 0
            width: 4
            height: 7
            radius: 1
            visible: false
            color: [Colors.primary, Colors.secondary, Colors.tertiary, Colors.error][palIndex]
        }
    }
}
