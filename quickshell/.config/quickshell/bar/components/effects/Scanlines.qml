import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "scanlines"
    readonly property string fxName: "Scanlines"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    visible: enabled

    Column {
        anchors.fill: parent

        Repeater {
            model: Math.ceil(root.height / 3)
            delegate: Rectangle {
                width: root.width
                height: 1
                color: "#000000"
                opacity: 0.18 * root.intensity
            }
        }
    }

    Rectangle {
        id: sweep
        width: parent.width
        height: 22
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.08 * root.intensity) }
            GradientStop { position: 1.0; color: "transparent" }
        }

        SequentialAnimation on y {
            running: root.enabled
            loops: Animation.Infinite
            NumberAnimation {
                from: -22
                to: root.height + 22
                duration: 6000 / root.speed
                easing.type: Easing.Linear
            }
        }
    }
}
