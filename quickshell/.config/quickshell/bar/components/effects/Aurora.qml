import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "aurora"
    readonly property string fxName: "Aurora"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    visible: enabled

    Repeater {
        model: 3

        delegate: Rectangle {
            required property int index
            readonly property var cols: [Colors.primary, Colors.secondary, Colors.tertiary]
            readonly property real h: root.height * (0.55 + index * 0.18)

            width: root.width * 1.6
            height: h
            y: root.height * 0.5 - h * 0.5 + (index - 1) * root.height * 0.1
            opacity: 0.22 * root.intensity

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: cols[index % 3] }
                GradientStop { position: 1.0; color: "transparent" }
            }

            SequentialAnimation on x {
                running: root.enabled
                loops: Animation.Infinite
                NumberAnimation {
                    from: -root.width * 0.6
                    to: root.width * 0.6
                    duration: (14000 + index * 3500) / root.speed
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    from: root.width * 0.6
                    to: -root.width * 0.6
                    duration: (14000 + index * 3500) / root.speed
                    easing.type: Easing.InOutSine
                }
            }
        }
    }
}
