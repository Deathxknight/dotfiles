import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property bool needed: false

    property real level: 0
    property real bass: 0
    property int  beatTick: 0
    property real beatStrength: 0

    property real _avgBass: 0.1
    property real _lastBeat: 0

    function handle(line) {
        const parts = line.split(";")
        let sum = 0, n = 0, b = 0, bn = 0
        for (let i = 0; i < parts.length; i++) {
            const v = parseInt(parts[i])
            if (isNaN(v)) continue
            const f = v / 100
            sum += f; n++
            if (i < 3) { b += f; bn++ }
        }
        if (n === 0) return

        level = sum / n
        const bs = bn > 0 ? b / bn : level
        bass = bs

        const now = Date.now()
        if (bs > 0.18 && bs > _avgBass * 1.4 && now - _lastBeat > 200) {
            _lastBeat = now
            beatStrength = Math.min(1, (bs - _avgBass) * 2 + 0.4)
            beatTick++
        }
        _avgBass = _avgBass * 0.97 + bs * 0.03
    }

    Process {
        id: cava
        running: root.needed
        command: ["bash", "-c",
            "cat > /tmp/qs-cava.conf <<'EOF'\n" +
            "[general]\nbars = 16\nframerate = 50\n" +
            "[input]\nmethod = pulse\nsource = auto\n" +
            "[output]\nmethod = raw\nraw_target = /dev/stdout\ndata_format = ascii\n" +
            "ascii_max_range = 100\nbar_delimiter = 59\nframe_delimiter = 10\nEOF\n" +
            "exec cava -p /tmp/qs-cava.conf"]
        stdout: SplitParser {
            onRead: line => root.handle(line)
        }
    }
}
