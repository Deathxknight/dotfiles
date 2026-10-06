import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "bubbles"
    readonly property string fxName: "Bubbles"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    visible: enabled

    Repeater {
        model: root.enabled ? 18 : 0

        delegate: Rectangle {
            required property int index
            readonly property real size: 3 + Rng.rand(index * 13 + 1) * 8
            readonly property real dur: (6000 + Rng.rand(index * 13 + 3) * 5000) / root.speed
            readonly property real colX: Rng.rand(index * 13 + 2) * root.width

            x: colX
            width: size
            height: size
            radius: size / 2
            color: Colors.secondary
            opacity: 0.0

            border.width: 1
            border.color: Colors.on_surface

            SequentialAnimation on y {
                running: root.enabled
                loops: Animation.Infinite
                NumberAnimation {
                    from: root.height + size
                    to: -size
                    duration: dur
                    easing.type: Easing.Linear
                }
                PauseAnimation { duration: Rng.rand(index * 13 + 4) * 800 }
            }

            SequentialAnimation on opacity {
                running: root.enabled
                loops: Animation.Infinite
                NumberAnimation { to: 0.35 * root.intensity; duration: dur * 0.15; easing.type: Easing.OutCubic }
                PauseAnimation { duration: dur * 0.7 }
                NumberAnimation { to: 0.0; duration: dur * 0.15; easing.type: Easing.InCubic }
            }
        }
    }
}
