import "../components"
import QtQuick
import Quickshell
import Quickshell.Io

Pill {
    id: root
    interactive: true
    leftPad: 12
    rightPad: 12

    property string profile: "balanced"

    readonly property string icon: profile === "power-saver" ? "\uf06c"
                                  : (profile === "balanced" ? "\uf24e" : "\uf0e7")

    readonly property color iconColor: profile === "performance" ? Colors.on_surface
                                       : (profile === "power-saver" ? Colors.primary
                                       : Colors.secondary)

    Process {
        id: ppdGet
        command: ["powerprofilesctl", "get"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.profile = text.trim() }
    }
    Timer { interval: 5000; running: true; repeat: true; onTriggered: ppdGet.running = true }

    onActivated: {
        const next = profile === "balanced" ? "performance"
                   : (profile === "performance" ? "power-saver" : "balanced")
        profile = next
        Quickshell.execDetached(["powerprofilesctl", "set", next])
    }

    PText {
        color: root.iconColor
        text: root.icon
    }
}
