

import "../.."
import QtQuick

Item {
    id: root

    readonly property string fxId: "template"
    readonly property string fxName: "Template"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    visible: enabled

    Rectangle {
        anchors.fill: parent
        color: Colors.primary
        opacity: 0.15 * root.intensity
    }
}
