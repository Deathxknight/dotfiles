import QtQuick

NumberAnimation {
    duration: 500
    easing.type: Easing.BezierSpline
    easing.bezierCurve: [0.38, 1.21, 0.22, 1.0, 1, 1]
}
