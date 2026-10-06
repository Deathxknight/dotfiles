import "components"
import QtQuick
import Quickshell
import Quickshell.Widgets

Item {
    id: root

    readonly property var list: {
        const v = NotifState.items.values
        const out = []
        for (let i = v.length - 1; i >= 0; i--) out.push(v[i])
        return out
    }
    onListChanged: NotifState.markRead()
    Component.onCompleted: NotifState.markRead()

    component Btn: Rectangle {
        id: btn
        property alias label: t.text
        property bool active: false
        signal clicked()
        implicitWidth: t.implicitWidth + 24
        implicitHeight: 30
        radius: 15
        color: active ? Colors.primary_fixed_dim : Theme.container
        PText {
            id: t
            anchors.centerIn: parent
            font.pixelSize: 12
            color: btn.active ? Colors.on_primary_fixed : Colors.outline
        }
        MouseArea {
            anchors.fill: parent
            onClicked: btn.clicked()
        }
    }

    PText {
        id: title
        anchors { left: parent.left; leftMargin: 20; top: parent.top; topMargin: 22 }
        text: "Notifications"
        font.pixelSize: 16
        font.bold: true
    }

    Row {
        anchors { right: parent.right; rightMargin: 16; verticalCenter: title.verticalCenter }
        spacing: 8

        Btn {
            label: NotifState.dnd ? "Do not disturb: on" : "Do not disturb"
            active: NotifState.dnd
            onClicked: NotifState.dnd = !NotifState.dnd
        }
        Btn {
            label: "Clear"
            onClicked: NotifState.clearAll()
        }
    }

    PText {
        anchors.centerIn: parent
        visible: root.list.length === 0
        text: "No notifications"
        color: Colors.outline
        font.pixelSize: 14
    }

    ListView {
        anchors { top: title.bottom; topMargin: 16; left: parent.left; right: parent.right; bottom: parent.bottom; margins: 14 }
        clip: true
        spacing: 8
        model: root.list

        delegate: Rectangle {
            id: card
            required property var modelData

            readonly property string iconSrc: {
                const m = modelData
                if (m.image !== "") return m.image
                if (m.appIcon === "") return ""
                if (m.appIcon.startsWith("/")) return "file://" + m.appIcon
                return Quickshell.iconPath(m.appIcon, true)
            }

            width: ListView.view.width
            height: content.implicitHeight + 24
            radius: 18
            color: cardMouse.containsMouse ? Qt.lighter(Theme.container, 1.25) : Theme.container

            MouseArea {
                id: cardMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    const a = card.modelData.actions
                    for (let i = 0; i < a.length; i++) {
                        if (a[i].identifier === "default") { a[i].invoke(); break }
                    }
                }
            }

            Row {
                id: content
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
                spacing: 10

                IconImage {
                    id: icon
                    width: 36
                    height: 36
                    source: card.iconSrc
                    visible: card.iconSrc !== ""
                }

                Column {
                    width: content.width - (icon.visible ? icon.width + content.spacing : 0) - 28
                    spacing: 2

                    PText {
                        width: parent.width
                        text: card.modelData.appName + "  ·  " + NotifState.ago(card.modelData.id)
                        font.pixelSize: 11
                        color: Colors.outline
                        elide: Text.ElideRight
                    }
                    PText {
                        width: parent.width
                        text: card.modelData.summary
                        font.pixelSize: 14
                        font.bold: true
                        elide: Text.ElideRight
                    }
                    PText {
                        width: parent.width
                        text: card.modelData.body
                        font.pixelSize: 12
                        color: Colors.outline
                        wrapMode: Text.WordWrap
                        maximumLineCount: 4
                        elide: Text.ElideRight
                        textFormat: Text.StyledText
                        visible: text !== ""
                    }
                }

                PText {
                    id: closeBtn
                    text: "\uf00d"
                    font.pixelSize: 14
                    color: Colors.outline

                    MouseArea {
                        anchors { fill: parent; margins: -8 }
                        onClicked: card.modelData.dismiss()
                    }
                }
            }
        }
    }
}
