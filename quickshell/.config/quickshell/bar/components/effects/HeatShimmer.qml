import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "shimmer"
    readonly property string fxName: "Heat shimmer"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    visible: enabled

    Rectangle {
        width: root.width * 0.7
        height: root.height
        y: 0
        opacity: 0.12 * root.intensity
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: Colors.tertiary }
            GradientStop { position: 1.0; color: "transparent" }
        }

        SequentialAnimation on x {
            running: root.enabled
            loops: Animation.Infinite
            NumberAnimation {
                from: -root.width * 0.7
                to: root.width
                duration: 9000 / root.speed
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                from: root.width
                to: -root.width * 0.7
                duration: 9000 / root.speed
                easing.type: Easing.InOutSine
            }
        }
    }

    Rectangle {
        width: root.width * 0.5
        height: root.height
        y: 0
        opacity: 0.09 * root.intensity
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: Colors.primary }
            GradientStop { position: 1.0; color: "transparent" }
        }

        SequentialAnimation on x {
            running: root.enabled
            loops: Animation.Infinite
            NumberAnimation {
                from: root.width
                to: -root.width * 0.5
                duration: 11000 / root.speed
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                from: -root.width * 0.5
                to: root.width
                duration: 11000 / root.speed
                easing.type: Easing.InOutSine
            }
        }
    }
}
