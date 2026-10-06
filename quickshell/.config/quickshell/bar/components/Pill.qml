import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    default property alias content: row.data
    property real leftPad: 15
    property real rightPad: 15
    property real corner: height / 2
    property real leftCorner: corner
    property real rightCorner: corner
    property real bottomLeftCorner: leftCorner
    property real bottomRightCorner: rightCorner
    property bool interactive: false
    property bool flattenBottom: false

    property color bgColor: "transparent"
    property color hoverColor: Qt.rgba(Theme.bar.r, Theme.bar.g, Theme.bar.b, 0.35)

    signal activated(var mouse)
    signal scrolled(var wheel)
    signal hoverEnter()
    signal hoverLeave()

    color: interactive && area.containsMouse ? hoverColor : bgColor
    implicitHeight: 40
    implicitWidth: row.implicitWidth + leftPad + rightPad
    topLeftRadius: leftCorner
    bottomLeftRadius: root.flattenBottom ? 0 : bottomLeftCorner
    topRightRadius: rightCorner
    bottomRightRadius: root.flattenBottom ? 0 : bottomRightCorner

    Behavior on color {
        ColorAnimation { duration: 100; easing.type: Easing.OutCubic }
    }

    RowLayout {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        x: root.leftPad
        spacing: 8
    }

    MouseArea {
        id: area
        anchors.fill: parent
        enabled: root.interactive
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        onWheel: (wheel) => root.scrolled(wheel)
        onEntered: root.hoverEnter()
        onExited: root.hoverLeave()
    }

    TapHandler {
        id: tapper
        enabled: root.interactive
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: (eventPoint, button) => {
            root.activated({ button: button, x: eventPoint.position.x, y: eventPoint.position.y })
        }
    }
}
