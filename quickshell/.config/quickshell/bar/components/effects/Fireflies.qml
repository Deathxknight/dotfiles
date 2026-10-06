import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "fireflies"
    readonly property string fxName: "Fireflies"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    visible: enabled

    Repeater {
        model: root.enabled ? 14 : 0

        delegate: Rectangle {
            required property int index
            readonly property real size: 3 + Rng.rand(index * 7 + 1) * 5
            readonly property real baseX: Rng.rand(index * 7 + 2) * (root.width - size)
            readonly property real baseY: Rng.rand(index * 7 + 3) * (root.height - size)

            width: size
            height: size
            radius: size / 2
            color: Colors.tertiary
            opacity: 0.45 * root.intensity

            SequentialAnimation on x {
                running: root.enabled
                loops: Animation.Infinite
                NumberAnimation {
                    to: baseX + Rng.range(index * 7 + 4, -40, 40)
                    duration: (3500 + Rng.rand(index * 7 + 5) * 4000) / root.speed
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: baseX
                    duration: (3500 + Rng.rand(index * 7 + 6) * 4000) / root.speed
                    easing.type: Easing.InOutSine
                }
            }

            SequentialAnimation on y {
                running: root.enabled
                loops: Animation.Infinite
                NumberAnimation {
                    to: baseY + Rng.range(index * 7 + 8, -14, 14)
                    duration: (4200 + Rng.rand(index * 7 + 9) * 3800) / root.speed
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: baseY
                    duration: (4200 + Rng.rand(index * 7 + 10) * 3800) / root.speed
                    easing.type: Easing.InOutSine
                }
            }

            SequentialAnimation on opacity {
                running: root.enabled
                loops: Animation.Infinite
                NumberAnimation { to: 0.15; duration: 2200 / root.speed; easing.type: Easing.InOutSine }
                NumberAnimation { to: 0.55 * root.intensity; duration: 2600 / root.speed; easing.type: Easing.InOutSine }
            }
        }
    }
}
