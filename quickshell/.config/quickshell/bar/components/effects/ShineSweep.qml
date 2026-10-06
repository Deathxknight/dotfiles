import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "shine"
    readonly property string fxName: "Shine sweep"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    opacity: enabled ? 1 : 0
    visible: opacity > 0.01
    Behavior on opacity { NumberAnimation { duration: 400 } }

    Rectangle {
        id: sheen
        width: 110
        height: root.height * 2.4
        y: -root.height * 0.7
        x: -200
        rotation: 22
        opacity: Math.min(1, 0.22 * root.intensity)
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0) }
            GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 1) }
            GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0) }
        }
    }

    SequentialAnimation {
        running: root.enabled
        loops: Animation.Infinite
        PauseAnimation { duration: 3800 / Math.max(0.2, root.speed) }
        NumberAnimation {
            target: sheen
            property: "x"
            from: -160
            to: root.width + 160
            duration: 1500 / Math.max(0.2, root.speed)
            easing.type: Easing.InOutCubic
        }
    }
}
