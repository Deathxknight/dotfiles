import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

PopupWindow {
    id: root

    required property var menuHandle
    property var parentWindow

    property real anchorX: 0
    property real anchorY: 0

    property var stack: []
    property var currentOpener: null

    implicitWidth: 220
    implicitHeight: currentOpener ? Math.min(column.implicitHeight + 12, 400) : 0

    color: "transparent"

    anchor.window: parentWindow
    anchor.rect.x: anchorX
    anchor.rect.y: anchorY
    grabFocus: true
    visible: false

    onMenuHandleChanged: {
        if (menuHandle) {
            var opener = openerComponent.createObject(root, { menu: menuHandle })
            if (opener) {
                stack = [{ opener: opener, title: "" }]
                currentOpener = opener
            }
        }
    }

    Component {
        id: openerComponent
        QsMenuOpener {}
    }

    Rectangle {
        id: card
        anchors.fill: parent
        color: Theme.container
        radius: 14
        clip: true


        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: Colors.primary
            opacity: 0.06
        }

        ColumnLayout {
            id: column
            anchors {
                fill: parent
                margins: 6
            }
            spacing: 0


            Rectangle {
                visible: root.stack.length > 1
                Layout.fillWidth: true
                implicitHeight: 32
                radius: 9
                color: hoverBack.containsMouse ? Theme.pillHover : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    spacing: 8
                    PText {
                        text: "\uf104"
                        color: Colors.primary
                        font.pixelSize: 13
                    }
                    PText {
                        text: root.stack.length > 0 ? root.stack[root.stack.length - 1].title : ""
                        color: Colors.primary
                        font.pixelSize: 13
                    }
                }

                MouseArea {
                    id: hoverBack
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        var newStack = root.stack.slice(0, -1)
                        Qt.callLater(function() {
                            root.stack = newStack
                            root.currentOpener = newStack[newStack.length - 1].opener
                        })
                    }
                }
            }


            Repeater {
                model: root.currentOpener ? root.currentOpener.children : null

                delegate: Rectangle {
                    id: row
                    required property var modelData
                    required property int index

                    Layout.fillWidth: true
                    implicitHeight: modelData.isSeparator ? 9 : 32
                    radius: 9
                    color: {
                        if (modelData.isSeparator) return "transparent"
                        if (!modelData.enabled) return "transparent"
                        return rowMouse.containsMouse ? Theme.pillHover : "transparent"
                    }

                    Rectangle {
                        visible: modelData.isSeparator
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        height: 1
                        color: Colors.outline_variant
                    }

                    RowLayout {
                        visible: !modelData.isSeparator
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 8

                        PText {
                            visible: modelData.checkState !== undefined &&
                                     modelData.checkState !== Qt.Unchecked
                            text: modelData.checkState === Qt.PartiallyChecked ? "\uf111" : "\uf00c"
                            color: Colors.primary
                            font.pixelSize: 12
                            Layout.preferredWidth: 14
                        }

                        Image {
                            visible: modelData.icon !== "" && modelData.icon !== undefined
                            source: modelData.icon
                            Layout.preferredWidth: 16
                            Layout.preferredHeight: 16
                            fillMode: Image.PreserveAspectFit
                        }

                        PText {
                            Layout.fillWidth: true
                            text: modelData.text
                            color: modelData.enabled ? Colors.on_surface : Colors.outline
                            opacity: modelData.enabled ? 1.0 : 0.5
                            font.pixelSize: 13
                            elide: Text.ElideRight
                        }

                        PText {
                            visible: modelData.hasChildren
                            text: "\uf105"
                            color: Colors.outline
                            font.pixelSize: 11
                        }
                    }

                    MouseArea {
                        id: rowMouse
                        anchors.fill: parent
                        enabled: modelData.enabled && !modelData.isSeparator
                        hoverEnabled: true
                        onClicked: {
                            if (modelData.hasChildren) {
                                var opener = openerComponent.createObject(root, { menu: modelData })
                                if (opener) {
                                    var newStack = root.stack.slice()
                                    newStack.push({ opener: opener, title: modelData.text })
                                    Qt.callLater(function() {
                                        root.stack = newStack
                                        root.currentOpener = opener
                                    })
                                }
                            } else {
                                modelData.triggered()
                                root.visible = false
                            }
                        }
                    }
                }
            }
        }
    }
}
