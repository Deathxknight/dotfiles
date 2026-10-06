import QtQuick
import QtQuick.Layouts

Item {
    id: root

    implicitWidth: 80
    implicitHeight: 8

    property real volume: 0
    property real maxVolume: 1.5
    property color trackColor: Colors.outline_variant
    property color fillColor: Colors.primary
    property bool interactive: false

    signal seekRequested(real newVolume)
    signal clicked()

    property bool _dragging: false
    property real _pressX: 0
    property bool _moved: false

    Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2
        color: root.trackColor

        Rectangle {
            id: fill
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: Math.max(parent.height, parent.width * Math.min(1, root.volume / root.maxVolume))
            radius: height / 2
            color: root.fillColor

            Behavior on width {
                NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
            }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        enabled: root.interactive
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true

        function volumeFromX(x) {
            const ratio = Math.max(0, Math.min(1, x / width))
            return ratio * root.maxVolume
        }

        onPressed: (mouse) => {
            root._dragging = true
            root._pressX = mouse.x
            root._moved = false

            root.seekRequested(volumeFromX(mouse.x))
        }

        onPositionChanged: (mouse) => {
            if (!root._dragging) return
            if (Math.abs(mouse.x - root._pressX) > 4) root._moved = true
            if (root._moved) root.seekRequested(volumeFromX(mouse.x))
        }

        onReleased: {
            root._dragging = false
            root._moved = false
        }

        onCanceled: {
            root._dragging = false
            root._moved = false
        }
    }
}
