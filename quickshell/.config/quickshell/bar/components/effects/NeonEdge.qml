import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "neon"
    readonly property string fxName: "Neon edge"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20
    property real audioLevel: 0

    opacity: enabled ? 1 : 0
    visible: opacity > 0.01
    Behavior on opacity { NumberAnimation { duration: 450 } }

    Gradient {
        id: neonGrad
        orientation: Gradient.Horizontal
        GradientStop { position: 0.0;    color: Colors.primary }
        GradientStop { position: 0.1667; color: Colors.secondary }
        GradientStop { position: 0.3333; color: Colors.tertiary }
        GradientStop { position: 0.5;    color: Colors.primary }
        GradientStop { position: 0.6667; color: Colors.secondary }
        GradientStop { position: 0.8333; color: Colors.tertiary }
        GradientStop { position: 1.0;    color: Colors.primary }
    }

    Repeater {
        model: 2

        delegate: Item {
            id: line
            required property int index
            width: root.width
            height: 6
            y: index === 0 ? 0 : root.height - height
            clip: true
            opacity: Math.min(1, (0.55 + root.audioLevel * 0.45) * root.intensity)
            Behavior on opacity { NumberAnimation { duration: 80 } }

            Item {
                id: mover
                width: line.width * 2
                height: line.height

                Rectangle {
                    width: parent.width
                    height: 6
                    y: 0
                    gradient: neonGrad
                    opacity: 0.20
                }
                Rectangle {
                    width: parent.width
                    height: 2
                    y: line.index === 0 ? 0 : 4
                    gradient: neonGrad
                    opacity: 0.95
                }

                NumberAnimation on x {
                    running: root.enabled
                    loops: Animation.Infinite
                    from: line.index === 0 ? 0 : -line.width
                    to: line.index === 0 ? -line.width : 0
                    duration: 7000 / Math.max(0.2, root.speed)
                }
            }
        }
    }
}
