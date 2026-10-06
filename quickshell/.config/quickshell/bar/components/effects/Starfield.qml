import "../.."
import "../../components"
import QtQuick


Item {
    id: root

    readonly property string fxId: "stars"
    readonly property string fxName: "Starfield"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    opacity: enabled ? 1 : 0
    visible: opacity > 0.01
    Behavior on opacity { NumberAnimation { duration: 500 } }

    Repeater {
        model: 34

        delegate: Rectangle {
            id: star
            required property int index

            property real fx: Math.random()
            property real fy: Math.random()
            property real peak: 0.35 + Math.random() * 0.65
            property int dur: 900 + Math.floor(Math.random() * 1800)
            property real size: 1.2 + Math.random() * 1.6

            x: fx * root.width
            y: fy * root.height
            width: size
            height: size
            radius: size / 2
            color: index % 3 === 0 ? Qt.lighter(Colors.primary, 1.8) : "white"
            opacity: 0.08
            scale: 0.8 + opacity * 0.7

            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 4.5
                height: width
                radius: width / 2
                color: parent.color
                opacity: 0.18
            }

            SequentialAnimation on opacity {
                running: root.enabled
                loops: Animation.Infinite
                PauseAnimation { duration: star.dur * 0.6 }
                NumberAnimation {
                    to: Math.min(1, star.peak * root.intensity)
                    duration: star.dur / Math.max(0.2, root.speed)
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: 0.08
                    duration: star.dur / Math.max(0.2, root.speed)
                    easing.type: Easing.InOutSine
                }
            }
        }
    }
}
