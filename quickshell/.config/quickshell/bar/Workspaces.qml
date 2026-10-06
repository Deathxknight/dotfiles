import "components"
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Rectangle {
    id: root
    color: Theme.container
    radius: height / 2
    implicitHeight: 40
    implicitWidth: row.implicitWidth + 4

    function wsFor(id) {
        const v = Hyprland.workspaces.values
        for (let i = 0; i < v.length; i++)
            if (v[i].id === id) return v[i]
        return null
    }

    function toRoman(n) {
        const map = ["I","II","III","IV","V","VI","VII","VIII","IX","X"]
        return map[n - 1] || String(n)
    }

    Process {
        id: dispatchProc
    }

    Row {
        id: row
        anchors.centerIn: parent

        Repeater {
            model: 5

            delegate: Item {
                id: btn
                required property int index
                readonly property int wsId: index + 1
                readonly property bool active: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === wsId : false
                readonly property bool occupied: root.wsFor(wsId) !== null

                height: 36
                width: active ? 62 : 38
                Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: btn.active ? Colors.primary_fixed_dim
                         : (ma.containsMouse ? Theme.bar : "transparent")
                    Behavior on color { ColorAnimation { duration: 250 } }
                }

                PText {
                    anchors.centerIn: parent
                    text: root.toRoman(btn.wsId)
                    font.pixelSize: 14
                    color: btn.active ? Colors.on_primary_fixed
                         : (btn.occupied ? Colors.outline : Colors.outline_variant)
                    Behavior on color { ColorAnimation { duration: 250 } }
                }

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton
                    onClicked: {
                        dispatchProc.exec([
                            "hyprctl", "dispatch",
                            'hl.dsp.focus({ workspace = "' + btn.wsId + '" })'
                        ])
                    }
                }
            }
        }
    }
}
