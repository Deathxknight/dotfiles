pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real vol: sink && sink.audio ? sink.audio.volume : 0
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false

    readonly property var player: {
        const v = Mpris.players.values
        for (let i = 0; i < v.length; i++)
            if (v[i].isPlaying) return v[i]
        return v.length > 0 ? v[0] : null
    }


    property string pendingPopout: ""
    property bool anyHovered: false
    property bool popupHovered: false
    property bool mediaPopupOpen: false
    property var trayMenuHandle: null

    PwObjectTracker {
        objects: [root.sink]
    }
}
