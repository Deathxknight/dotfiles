import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "ripples"
    readonly property string fxName: "Hover ripples"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    property real barMouseX: -300
    property real barMouseY: -300

    readonly property int poolSize: 7
    property var rings: []
    property real lastX: -999
    property real lastY: -999
    property real sinceSpawn: 0
    property bool wasHot: false

    visible: enabled

    Component.onCompleted: {
        const a = []
        for (let i = 0; i < poolSize; i++) a.push({ x: 0, y: 0, age: 1 })
        rings = a
    }

    function spawn(x, y) {
        for (let i = 0; i < poolSize; i++) {
            const r = rings[i]
            if (r.age < 1) continue
            r.x = x
            r.y = y
            r.age = 0
            lastX = x
            lastY = y
            sinceSpawn = 0
            return
        }
    }

    FrameAnimation {
        running: root.enabled
        onTriggered: {
            const dt = Math.min(frameTime, 0.05)
            const mx = root.barMouseX, my = root.barMouseY
            const hot = mx >= 0 && my >= 0
            root.sinceSpawn += dt

            if (hot) {
                if (!root.wasHot) root.spawn(mx, my)
                else if (root.sinceSpawn > 0.12
                         && Math.hypot(mx - root.lastX, my - root.lastY) > 28)
                    root.spawn(mx, my)
            }
            root.wasHot = hot

            for (let i = 0; i < root.poolSize; i++) {
                const it = rep.itemAt(i)
                if (!it) continue
                const r = root.rings[i]
                if (r.age >= 1) { it.visible = false; continue }
                r.age = Math.min(1, r.age + dt * 1.1 * root.speed)
                const e = 1 - Math.pow(1 - r.age, 3)
                const s = 8 + e * 110
                it.visible = true
                it.width = s
                it.height = s
                it.x = r.x - s / 2
                it.y = r.y - s / 2
                it.opacity = (1 - r.age) * 0.55 * Math.min(1.5, root.intensity)
            }
        }
    }

    Repeater {
        id: rep
        model: root.poolSize

        delegate: Rectangle {
            required property int index
            visible: false
            color: "transparent"
            radius: width / 2
            border.width: 1.5
            border.color: index % 2 === 0 ? Colors.primary : Colors.tertiary
        }
    }
}
