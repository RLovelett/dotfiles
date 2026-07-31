import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Notifications
import qs.theme
import "NotificationText.js" as NotificationText

Scope {
  id: root

  required property Theme theme
  property var entries: []
  property var fullscreenByScreen: ({})

  readonly property int defaultLowTimeout: 4000
  readonly property int defaultNormalTimeout: 6000

  NotificationServer {
    id: server

    keepOnReload: false
    persistenceSupported: false
    bodySupported: true
    bodyMarkupSupported: false
    bodyHyperlinksSupported: false
    bodyImagesSupported: false
    actionsSupported: false
    actionIconsSupported: false
    imageSupported: false
    inlineReplySupported: false

    onNotification: notification => root.receive(notification)
  }

  IpcHandler {
    target: "notifications"

    function dismissLatest(): void {
      root.dismissLatest()
    }

    function clear(): void {
      root.clear()
    }
  }

  Component {
    id: entryComponent

    NotificationEntry {}
  }

  function plainText(value) {
    return NotificationText.plainText(value)
  }

  function focusedScreenName() {
    const monitor = Hyprland.monitors.values.find(candidate => candidate.focused)
      || Hyprland.monitors.values[0]
    return monitor !== undefined && monitor !== null ? monitor.name : ""
  }

  function receive(notification) {
    notification.tracked = true
    const replacement = entries.find(entry => entry.notificationId === notification.id
      && entry.appName === (notification.appName || "Unknown application")
      && entry.lifecycle !== NotificationEntry.Closing)
    if (replacement !== undefined) {
      replacement.updateFrom(notification)
      return
    }

    const screenName = focusedScreenName()
    const entry = entryComponent.createObject(root, {
      owner: root,
      sourceNotification: notification,
      targetScreenName: screenName,
      enterDuration: root.theme.motion.emphasized,
      exitDuration: root.theme.motion.standard,
      defaultLowTimeout: root.defaultLowTimeout,
      defaultNormalTimeout: root.defaultNormalTimeout
    })
    if (entry === null) {
      notification.tracked = false
      return
    }
    entry.updateFrom(notification)
    entries = [...entries, entry]
    promoteForScreen(screenName)
  }

  function setScreenFullscreen(screenName, fullscreen) {
    const next = Object.assign({}, fullscreenByScreen)
    next[screenName] = fullscreen
    fullscreenByScreen = next
    if (!fullscreen)
      promoteForScreen(screenName)
  }

  function releaseScreen(screenName) {
    const fallback = focusedScreenName()
    entries.forEach(entry => {
      if (entry.targetScreenName === screenName)
        entry.targetScreenName = fallback
    })
    promoteForScreen(fallback)
  }

  function promoteForScreen(screenName) {
    if (!screenName)
      return
    let occupied = entries.filter(entry => entry.targetScreenName === screenName
      && entry.lifecycle !== NotificationEntry.Queued
      && entry.lifecycle !== NotificationEntry.Closing).length
    while (occupied < theme.metrics.notificationStackLimit) {
      const fullscreen = fullscreenByScreen[screenName] === true
      const next = entries.find(entry => entry.targetScreenName === screenName
        && entry.lifecycle === NotificationEntry.Queued
        && (!fullscreen || entry.urgency === NotificationUrgency.Critical))
      if (next === undefined)
        break
      next.promote()
      occupied++
    }
  }

  function dismissLatest() {
    for (let index = entries.length - 1; index >= 0; index--) {
      if (entries[index].lifecycle !== NotificationEntry.Closing) {
        entries[index].beginClose(NotificationEntry.Dismissed)
        return
      }
    }
  }

  function clear() {
    [...entries].forEach(entry => entry.beginClose(NotificationEntry.Dismissed))
  }

  function removeEntry(entry) {
    const screenName = entry.targetScreenName
    entries = entries.filter(candidate => candidate !== entry)
    Qt.callLater(() => entry.destroy())
    Qt.callLater(() => promoteForScreen(screenName))
  }
}
