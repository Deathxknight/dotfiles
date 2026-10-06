import "components"
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Item {
    id: root

    signal closeRequested()

    property var entries: []

    function parse() {
        try {
            const d = JSON.parse(file.text())
            root.entries = d.clipboardHistory || []
        } catch (e) {
            root.entries = []
        }
    }

    FileView {
        id: file
        path: Quickshell.env("HOME") + "/.config/clipse/clipboard_history.json"
        watchChanges: true
        onFileChanged: file.reload()
        onLoaded: root.parse()
    }

    PText {
        id: title
        anchors { left: parent.left; leftMargin: 20; top: parent.top; topMargin: 22 }
        text: "Clipboard"
        font.pixelSize: 16
        font.bold: true
    }

    Rectangle {
        anchors { right: parent.right; rightMargin: 16; verticalCenter: title.verticalCenter }
        implicitWidth: clearText.implicitWidth + 24
        implicitHeight: 30
        radius: 15
        color: Theme.container

        PText {
            id: clearText
            anchors.centerIn: parent
            text: "Clear"
            font.pixelSize: 12
            color: Colors.outline
        }
        MouseArea {
            anchors.fill: parent
            onClicked: Quickshell.execDetached(["clipse", "-clear"])
        }
    }

    PText {
        anchors.centerIn: parent
        visible: root.entries.length === 0
        text: "Clipboard is empty"
        color: Colors.outline
        font.pixelSize: 14
    }

    ListView {
        anchors { top: title.bottom; topMargin: 16; left: parent.left; right: parent.right; bottom: parent.bottom; margins: 14 }
        clip: true
        spacing: 8
        model: root.entries

        delegate: Rectangle {
            id: card
            required property var modelData

            readonly property bool isImage: !!modelData.filePath && modelData.filePath !== "null"

            width: ListView.view.width
            height: isImage ? 120 : Math.max(44, Math.min(84, label.implicitHeight + 24))
            radius: 16
            color: ma.containsMouse ? Qt.lighter(Theme.container, 1.25) : Theme.container

            PText {
                id: label
                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; margins: 12 }
                visible: !card.isImage
                text: card.modelData.value
                font.pixelSize: 13
                wrapMode: Text.Wrap
                maximumLineCount: 3
                elide: Text.ElideRight
            }

            Image {
                anchors { fill: parent; margins: 8 }
                visible: card.isImage
                source: card.isImage ? "file://" + card.modelData.filePath : ""
                fillMode: Image.PreserveAspectFit
                asynchronous: true
            }

            MouseArea {
                id: ma
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if (card.isImage)
                        Quickshell.execDetached(["sh", "-c", 'wl-copy --type image/png < "$1"', "sh", card.modelData.filePath])
                    else
                        Quickshell.execDetached(["wl-copy", "--", card.modelData.value])
                    root.closeRequested()
                }
            }
        }
    }
}
