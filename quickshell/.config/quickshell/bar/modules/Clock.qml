import "../components"
import QtQuick
import Quickshell
import Quickshell.Io

Pill {
    id: root
    interactive: true

    property bool alt: false

    onActivated: alt = !alt

    SystemClock { id: clock; precision: SystemClock.Minutes }

    PText {
        color: Colors.primary
        text: Qt.formatDateTime(clock.date, root.alt ? "ddd, dd. MMM  hh:mm AP" : "hh:mm AP")
    }
}
