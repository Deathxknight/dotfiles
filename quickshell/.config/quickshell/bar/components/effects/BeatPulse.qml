import "../.."
import "../../components"
import QtQuick

Item {
    id: root

    readonly property string fxId: "beat"
    readonly property string fxName: "Beat pulse"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    property real audioLevel: 0
    property real bass: 0
    property int  beatTick: 0
    property real beatStrength: 0

    property real shown: audioLevel
    Behavior on shown { NumberAnimation { duration: 90 } }

    property real flash: 0
    onBeatTickChanged: {
        if (!enabled) return
        flashAnim.stop()
        flashAnim.from = Math.min(1, 0.4 + beatStrength)
        flashAnim.start()
    }
    NumberAnimation {
        id: flashAnim
        target: root
        property: "flash"
        to: 0
        duration: 450 / Math.max(0.2, root.speed)
        easing.type: Easing.OutCubic
    }

    readonly property real glow: Math.min(1, (0.10 + shown * 0.5 + flash * 0.45) * intensity)

    visible: enabled

    Rectangle {
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
        width: parent.width * (0.25 + 0.15 * root.flash)
        opacity: root.glow
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: Colors.primary }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    Rectangle {
        anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
        width: parent.width * (0.25 + 0.15 * root.flash)
        opacity: root.glow
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: Colors.secondary }
        }
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        height: 2
        width: parent.width * (0.15 + 0.85 * root.shown)
        radius: 1
        color: Colors.primary
        opacity: Math.min(1, (0.25 + root.flash * 0.75) * root.intensity)
    }
}
