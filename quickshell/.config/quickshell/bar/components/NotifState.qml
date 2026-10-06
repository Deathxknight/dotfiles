pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property bool dnd: false
    property int unread: 0
    property var arrived: ({})
    property var popups: []

    readonly property var items: server.trackedNotifications
    readonly property int count: server.trackedNotifications.values.length
    readonly property int unreadShown: Math.min(unread, count)

    NotificationServer {
        id: server
        keepOnReload: true
        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: (n) => {
            root.arrived[n.id] = Date.now()
            root.popups = root.popups.concat([n.id])
            n.tracked = true
            root.unread += 1
        }
    }

    function hidePopup(id) { popups = popups.filter(x => x !== id) }
    function markRead() { unread = 0 }

    function clearAll() {
        const v = server.trackedNotifications.values
        for (let i = v.length - 1; i >= 0; i--) v[i].dismiss()
        popups = []
        unread = 0
    }

    function ago(id) {
        const t = arrived[id]
        if (!t) return ""
        const s = Math.floor((Date.now() - t) / 1000)
        if (s < 60) return "now"
        if (s < 3600) return Math.floor(s / 60) + "m"
        if (s < 86400) return Math.floor(s / 3600) + "h"
        return Math.floor(s / 86400) + "d"
    }
}
