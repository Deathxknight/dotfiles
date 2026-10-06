import "components"
import QtQuick
import QtQuick.Effects

Item {
    id: root

    property real radius: 20

    property real barMouseX: -300
    property real barMouseY: -300

    property real audioLevel: 0
    property real bass: 0
    property int  beatTick: 0
    property real beatStrength: 0

    Item {
        id: maskItem
        anchors.fill: parent
        visible: false
        layer.enabled: true
        Rectangle { anchors.fill: parent; radius: root.radius }
    }

    readonly property var fxModel: [
        { file: "GifOverlay.qml",  id: "gif",      def: false },
        { file: "Aurora.qml",      id: "aurora",    def: false },
        { file: "Rain.qml",        id: "rain",      def: false },
        { file: "Snow.qml",        id: "snow",      def: false },
        { file: "Fireflies.qml",   id: "fireflies", def: false },
        { file: "Scanlines.qml",   id: "scanlines", def: false },
        { file: "Bubbles.qml",     id: "bubbles",   def: false },
        { file: "HeatShimmer.qml", id: "shimmer",   def: false },
        { file: "MatrixRain.qml",  id: "matrix",    def: false },
        { file: "BeatPulse.qml",   id: "beat",      def: false },
        { file: "MouseGlow.qml",   id: "mouseglow", def: false },
        { file: "Sparkles.qml",    id: "sparkles",  def: false },
        { file: "Confetti.qml",    id: "confetti",  def: true  },
        { file: "ShineSweep.qml",  id: "shine",    def: false },
        { file: "Starfield.qml",  id: "stars",    def: false },
        { file: "Sakura.qml",    id: "sakura",   def: false },
        { file: "NeonEdge.qml",  id: "neon",     def: false },
        { file: "Ripples.qml",   id: "ripples",  def: false },
        { file: "Blobs.qml",     id: "blobs",    def: false },
    ]

    Item {
        id: fxHost
        anchors.fill: parent
        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: maskItem
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }

        Repeater {
            model: root.fxModel

            delegate: Loader {
                id: fxLoader
                required property var modelData
                anchors.fill: parent
                source: "components/effects/" + modelData.file
                active: true
                asynchronous: false

                onLoaded: {
                    if (!item) return
                    item.barRadius = root.radius
                    if (modelData.def !== undefined && item.fxDefault === undefined)
                        item.fxDefault = modelData.def
                    BarSettings.registerEffect(modelData.id, modelData.def === true)
                    item.enabled   = Qt.binding(() => BarSettings.effectEnabled(modelData.id))
                    item.intensity = Qt.binding(() => BarSettings.effectIntensity)
                    item.speed     = Qt.binding(() => BarSettings.effectSpeed)

                    if (item.barMouseX !== undefined)
                        item.barMouseX = Qt.binding(() => root.barMouseX)
                    if (item.barMouseY !== undefined)
                        item.barMouseY = Qt.binding(() => root.barMouseY)
                    if (item.audioLevel !== undefined)
                        item.audioLevel = Qt.binding(() => root.audioLevel)
                    if (item.bass !== undefined)
                        item.bass = Qt.binding(() => root.bass)
                    if (item.beatTick !== undefined)
                        item.beatTick = Qt.binding(() => root.beatTick)
                    if (item.beatStrength !== undefined)
                        item.beatStrength = Qt.binding(() => root.beatStrength)
                }
            }
        }
    }
}
