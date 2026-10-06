import "components"
import QtQuick
import Quickshell
import Quickshell.Io




Item {
    id: root

    property var held: []
    property string combo: ""
    property bool shown: false

    readonly property string superGlyph: "\uf17a"

    visible: shown
    width: pill.width
    height: pill.height

    readonly property var names: ({
        "KEY_ENTER": "Enter", "KEY_KPENTER": "Enter", "KEY_SPACE": "Space",
        "KEY_TAB": "Tab", "KEY_ESC": "Esc", "KEY_BACKSPACE": "\u232b",
        "KEY_DELETE": "Del", "KEY_INSERT": "Ins", "KEY_HOME": "Home", "KEY_END": "End",
        "KEY_PAGEUP": "PgUp", "KEY_PAGEDOWN": "PgDn",
        "KEY_UP": "\u2191", "KEY_DOWN": "\u2193", "KEY_LEFT": "\u2190", "KEY_RIGHT": "\u2192",
        "KEY_LEFTSHIFT": "Shift", "KEY_RIGHTSHIFT": "Shift",
        "KEY_LEFTCTRL": "Ctrl", "KEY_RIGHTCTRL": "Ctrl",
        "KEY_LEFTALT": "Alt", "KEY_RIGHTALT": "Alt",
        "KEY_MINUS": "-", "KEY_EQUAL": "=", "KEY_COMMA": ",", "KEY_DOT": ".",
        "KEY_SLASH": "/", "KEY_BACKSLASH": "\\", "KEY_SEMICOLON": ";",
        "KEY_APOSTROPHE": "'", "KEY_GRAVE": "`",
        "KEY_LEFTBRACE": "[", "KEY_RIGHTBRACE": "]",
        "KEY_SYSRQ": "PrtSc", "KEY_PRINT": "PrtSc", "KEY_CAPSLOCK": "Caps"
    })

    function label(k) {
        if (names[k] !== undefined) return names[k]
        const n = k.replace("KEY_", "")
        if (n.length <= 1) return n
        if (/^F\d+$/.test(n)) return n
        return n.charAt(0) + n.slice(1).toLowerCase()
    }

    function handle(line) {
        const m = line.trim().match(/^(KEY_[A-Z0-9_]+) (pressed|released)$/)
        if (!m) return
        const key = m[1]
        const down = m[2] === "pressed"

        const s = held.filter(k => k !== key)
        if (down) s.push(key)
        held = s

        const superDown = held.indexOf("KEY_LEFTMETA") >= 0 || held.indexOf("KEY_RIGHTMETA") >= 0
        if (superDown) {
            lingerTimer.stop()
            if (down) {
                const others = held
                    .filter(k => k !== "KEY_LEFTMETA" && k !== "KEY_RIGHTMETA")
                    .map(label)
                combo = superGlyph + (others.length ? "  +  " + others.join(" + ") : "")
            }
            shown = true
        } else if (shown) {
            lingerTimer.restart()
        }
    }

    Timer {
        id: lingerTimer
        interval: 500
        onTriggered: root.shown = false
    }

    Process {
        running: true
        command: ["python3", Quickshell.shellPath("keywatch.py")]
        stdout: SplitParser { onRead: data => root.handle(data) }
        stderr: SplitParser { onRead: data => console.warn("[KeyDisplay]", data) }
        onExited: {
            console.warn("[KeyDisplay] keywatch.py exited")
            root.held = []
            root.shown = false
        }
    }

    Pill {
        id: pill
        leftPad: 12
        rightPad: 12
        PText {
            text: root.combo
            color: Colors.primary
            font.pixelSize: 13
        }
    }
}
