import "components"
import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root

    property var menu: null        // root menu handle (BarState.trayMenuHandle)
    property var stack: []         // parent menus, for submenu navigation
    property var current: menu     // menu currently shown
    readonly property real wantedHeight: column.implicitHeight + 16

    signal closeRequested()

    color: "transparent"
    implicitWidth: 240
    implicitHeight: wantedHeight

    onMenuChanged: {
        stack = []
        current = menu
    }

    QsMenuOpener {
        id: opener
        menu: root.current
    }

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 8
        spacing: 2


        Rectangle {
            visible: root.stack.length > 0
            Layout.fillWidth: true
            implicitHeight: visible ? 32 : 0
            radius: 9
            color: backMouse.containsMouse ? Theme.pillHover : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 8
                PText { text: "\uf104"; color: Colors.primary; font.pixelSize: 12 }
                PText { text: "Back"; color: Colors.on_surface; font.pixelSize: 13; Layout.fillWidth: true }
            }

            MouseArea {
                id: backMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    const s = root.stack.slice()
                    root.current = s.pop()
                    root.stack = s
                }
            }
        }

        Repeater {
            model: opener.children

            delegate: Rectangle {
                id: row
                required property var modelData

                Layout.fillWidth: true
                implicitHeight: modelData.isSeparator ? 9 : 32
                radius: 9
                color: (!modelData.isSeparator && modelData.enabled && rowMouse.containsMouse)
                       ? Theme.pillHover : "transparent"

                Rectangle {
                    visible: row.modelData.isSeparator
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    height: 1
                    color: Colors.outline_variant
                }

                RowLayout {
                    visible: !row.modelData.isSeparator
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    PText {
                        visible: row.modelData.checkState !== undefined
                                 && row.modelData.checkState !== Qt.Unchecked
                        text: row.modelData.checkState === Qt.PartiallyChecked ? "\uf111" : "\uf00c"
                        color: Colors.primary
                        font.pixelSize: 12
                        Layout.preferredWidth: 14
                    }

                    Image {
                        visible: row.modelData.icon !== "" && row.modelData.icon !== undefined
                        source: row.modelData.icon
                        sourceSize.width: 32
                        sourceSize.height: 32
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                        fillMode: Image.PreserveAspectFit
                    }

                    PText {
                        Layout.fillWidth: true
                        text: row.modelData.text
                        color: row.modelData.enabled ? Colors.on_surface : Colors.outline
                        opacity: row.modelData.enabled ? 1.0 : 0.5
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }

                    PText {
                        visible: row.modelData.hasChildren
                        text: "\uf105"
                        color: Colors.outline
                        font.pixelSize: 11
                    }
                }

                MouseArea {
                    id: rowMouse
                    anchors.fill: parent
                    enabled: row.modelData.enabled && !row.modelData.isSeparator
                    hoverEnabled: true
                    onClicked: {
                        if (row.modelData.hasChildren) {
                            root.stack = root.stack.concat([root.current])
                            root.current = row.modelData
                        } else {
                            row.modelData.triggered()
                            root.closeRequested()
                        }
                    }
                }
            }
        }
    }
}
