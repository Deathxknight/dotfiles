import QtQuick
import Quickshell
import Caelestia.Blobs

Item {
    id: root

    property real popupCenterX: 0
    property real popupWidth: 0
    property real popupFullHeight: 0
    property real popupScale: 1

    property real barHeight: 40
    property real barRadius: 20
    property real popupRadius: 24
    property real blobSmoothing: 48
    property real mergeOverlap: 10
    property real deformAmount: 0.15
    property color blobColor: "transparent"

    readonly property alias popupBody: popupBody

    property BlobGroup group: BlobGroup {
        smoothing: root.blobSmoothing
        color: root.blobColor
        cornerFill: true
    }


    BlobRect {
        group: root.group
        x: 0
        y: 0
        implicitWidth: root.width
        implicitHeight: root.barHeight
        deformScale: 0
        radius: root.barRadius
    }

    BlobRect {
        id: popupBody
        group: root.group
        x: root.popupCenterX - implicitWidth / 2
        y: root.barHeight - root.mergeOverlap - (root.popupFullHeight + 5) * root.popupScale
        implicitWidth: root.popupWidth
        implicitHeight: root.popupFullHeight + root.mergeOverlap
        deformScale: root.deformAmount / 10000

        topLeftRadius: 0
        topRightRadius: 0
        bottomLeftRadius: root.popupRadius
        bottomRightRadius: root.popupRadius
    }
}
