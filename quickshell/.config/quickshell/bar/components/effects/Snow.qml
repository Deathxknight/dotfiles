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
        model: root.enabled ? 34 : 0

        delegate: Rectangle {
            required property int index
            readonly property real size: 1.2 + Rng.rand(index * 9 + 1) * 2.0
            readonly property real baseX: Rng.rand(index * 9 + 2) * root.width
            readonly property real dur: (4200 + Rng.rand(index * 9 + 3) * 4800) / root.speed
            readonly property real sway: 3 + Rng.rand(index * 9 + 4) * 5

            width: size
            height: size
            radius: size / 2
            color: Colors.on_surface
            opacity: 0.6 * root.intensity

            property real py: -size
            x: baseX + Math.sin(py / 12) * sway
            y: py

            SequentialAnimation on py {
                running: root.enabled
                loops: Animation.Infinite
                NumberAnimation {
                    from: -size
                    to: root.height + size
                    duration: dur
                    easing.type: Easing.Linear
                }
                PauseAnimation { duration: Rng.rand(index * 9 + 5) * 1400 }
            }
        }
    }
}
