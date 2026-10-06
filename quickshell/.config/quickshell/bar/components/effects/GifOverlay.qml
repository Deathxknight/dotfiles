import "../.."
import "../../components"
import QtQuick
import Quickshell
import Quickshell.Io


Item {
    id: root

    readonly property string fxId: "gif"
    readonly property string fxName: "GIF overlay"
    property bool fxDefault: false

    property bool enabled: false
    property real intensity: 1.0
    property real speed: 1.0
    property real barRadius: 20

    readonly property string dir: Quickshell.env("HOME") + "/.config/quickshell/bar/gifs"
    property var files: []
    property int idx: 0
    property string current: ""
    property bool fading: false

    opacity: enabled ? 1 : 0
    visible: opacity > 0.01
    Behavior on opacity { NumberAnimation { duration: 400 } }

    Process {
        id: lister
        running: false
        command: ["bash", "-c",
            "ls -1 \"$HOME/.config/quickshell/bar/gifs\" 2>/dev/null | grep -iE '[.](gif|webp|apng)$'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const list = text.split("\n").map(s => s.trim()).filter(s => s.length > 0)
                if (JSON.stringify(list) !== JSON.stringify(root.files)) {
                    root.files = list
                    if (list.indexOf(root.current) < 0) {
                        root.idx = 0
                        root.current = list.length > 0 ? list[0] : ""
                    }
                }
            }
        }
    }

    Timer {
        interval: 30000
        running: root.enabled
        repeat: true
        triggeredOnStart: true
        onTriggered: lister.running = true
    }

    Timer {
        id: swap
        interval: 600
        onTriggered: {
            if (root.files.length > 0) {
                root.idx = (root.idx + 1) % root.files.length
                root.current = root.files[root.idx]
            }
            root.fading = false
        }
    }

    Timer {
        interval: 25000
        running: root.enabled && root.files.length > 1
        repeat: true
        onTriggered: { root.fading = true; swap.start() }
    }

    AnimatedImage {
        id: gif
        anchors.fill: parent
        source: root.current !== "" ? "file://" + root.dir + "/" + root.current : ""
        playing: root.enabled && root.visible
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
        opacity: (root.current !== "" && !root.fading) ? Math.min(1, 0.45 * root.intensity) : 0
        Behavior on opacity { NumberAnimation { duration: 550; easing.type: Easing.InOutQuad } }
    }
}
