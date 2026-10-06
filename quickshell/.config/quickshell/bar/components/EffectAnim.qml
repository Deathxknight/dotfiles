import QtQuick

NumberAnimation {
    duration: 200
    easing.type: Easing.BezierSpline
    easing.bezierCurve: [0.34, 0.8, 0.34, 1.0, 1, 1]
}
