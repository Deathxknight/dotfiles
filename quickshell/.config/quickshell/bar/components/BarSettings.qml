pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias scheme: adapter.scheme
    property alias saturation: adapter.saturation
    property alias barOpacity: adapter.barOpacity
    property alias transparent: adapter.transparent
    property alias effectIntensity: adapter.effectIntensity
    property alias effectSpeed: adapter.effectSpeed
    property alias effectStates: adapter.effectStates

    property var effectDefaults: ({})

    signal confettiRequested()

    function triggerConfetti() {
        confettiRequested()
    }

    Timer {
        id: saveTimer
        interval: 300
        onTriggered: file.writeAdapter()
    }

    function effectEnabled(id) {
        const v = effectStates[id]
        if (v !== undefined) return v
        return effectDefaults[id] === true
    }

    function registerEffect(id, defaultOn) {
        if (effectDefaults[id] === undefined) {
            const d = Object.assign({}, effectDefaults)
            d[id] = defaultOn === true
            effectDefaults = d
        }
    }

    function setEffect(id, on) {
        const s = Object.assign({}, effectStates)
        s[id] = on
        effectStates = s
        saveTimer.restart()
    }

    FileView {
        id: file
        path: Quickshell.env("HOME") + "/.config/quickshell-bar-settings.json"
        blockLoading: true
        onAdapterUpdated: saveTimer.restart()
        onLoadFailed: error => {
            if (error === FileViewError.FileNotFound) file.writeAdapter()
        }

        adapter: JsonAdapter {
            id: adapter
            property string scheme: "matugen"
            property real saturation: 1.0
            property real barOpacity: 0.6
            property bool transparent: false
            property real effectIntensity: 1.0
            property real effectSpeed: 1.0
            property var effectStates: ({})
        }
    }
}
