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
        model: root.enabled ? 22 : 0

        delegate: Item {
            required property int index
            readonly property real len: 8 + Rng.rand(index * 3 + 1) * 10
            readonly property real dur: (900 + Rng.rand(index * 3 + 3) * 900) / root.speed
            readonly property real colX: Rng.rand(index * 3 + 2) * root.width

            x: colX
            width: 1
            height: len

            Rectangle {
                anchors.fill: parent
                color: Colors.secondary
                opacity: 0.35 * root.intensity
            }

            SequentialAnimation on y {
                running: root.enabled
                loops: Animation.Infinite
                NumberAnimation {
                    from: -len
                    to: root.height + len
                    duration: dur
                    easing.type: Easing.Linear
                }
                PauseAnimation { duration: Rng.rand(index * 3 + 4) * 600 }
            }
        }
    }
}
