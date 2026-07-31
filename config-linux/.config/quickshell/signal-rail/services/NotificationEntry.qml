import QtQuick
import Quickshell.Services.Notifications

QtObject {
  id: root

  enum Lifecycle { Queued, Entering, Visible, Closing }
  enum CloseKind { Dismissed, Expired, Remote }

  required property var owner
  required property var sourceNotification
  required property string targetScreenName
  required property int enterDuration
  required property int exitDuration
  required property int defaultLowTimeout
  required property int defaultNormalTimeout

  property int notificationId: 0
  property string appName: ""
  property string appIcon: ""
  property string summary: ""
  property string body: ""
  property int urgency: NotificationUrgency.Normal
  property int lifecycle: NotificationEntry.Queued
  property int closeKind: NotificationEntry.Dismissed
  property int remainingTimeout: 0
  property double timeoutDeadline: 0
  property bool timeoutPaused: false

  property Timer enterTimer: Timer {
    interval: Math.max(1, root.enterDuration)
    onTriggered: root.finishEntering()
  }

  property Timer expiryTimer: Timer {
    onTriggered: root.beginClose(NotificationEntry.Expired)
  }

  property Timer exitTimer: Timer {
    interval: Math.max(1, root.exitDuration)
    onTriggered: root.finalizeClose()
  }

  property Connections sourceConnection: Connections {
    target: root.sourceNotification
    enabled: target !== null

    function onClosed(reason) {
      root.sourceNotification = null
      root.beginClose(NotificationEntry.Remote)
    }
  }

  function updateFrom(notification) {
    sourceNotification = notification
    notificationId = notification.id
    appName = notification.appName || "Unknown application"
    // Hyprshot supplies its saved file through the freedesktop image hint on
    // this Quickshell version, even though it is conceptually the app icon.
    appIcon = notification.image || notification.appIcon || "dialog-information"
    summary = owner.plainText(notification.summary)
    body = owner.plainText(notification.body)
    urgency = notification.urgency
    remainingTimeout = timeoutFor(notification.expireTimeout)
    timeoutPaused = false
    enterTimer.stop()
    expiryTimer.stop()
    exitTimer.stop()

    if (lifecycle === NotificationEntry.Visible)
      startExpiry()
  }

  function timeoutFor(senderTimeout) {
    if (senderTimeout > 0)
      return Math.round(senderTimeout * 1000)
    if (senderTimeout === 0 || urgency === NotificationUrgency.Critical)
      return 0
    return urgency === NotificationUrgency.Low ? defaultLowTimeout : defaultNormalTimeout
  }

  function promote() {
    if (lifecycle !== NotificationEntry.Queued)
      return
    lifecycle = NotificationEntry.Entering
    if (enterDuration === 0)
      finishEntering()
    else
      enterTimer.restart()
  }

  function finishEntering() {
    if (lifecycle !== NotificationEntry.Entering)
      return
    lifecycle = NotificationEntry.Visible
    startExpiry()
  }

  function startExpiry() {
    if (remainingTimeout <= 0 || timeoutPaused)
      return
    timeoutDeadline = Date.now() + remainingTimeout
    expiryTimer.interval = Math.max(1, remainingTimeout)
    expiryTimer.restart()
  }

  function setHovered(hovered) {
    if (lifecycle !== NotificationEntry.Visible || remainingTimeout <= 0)
      return
    if (hovered && expiryTimer.running) {
      remainingTimeout = Math.max(1, Math.round(timeoutDeadline - Date.now()))
      expiryTimer.stop()
      timeoutPaused = true
    } else if (!hovered && timeoutPaused) {
      timeoutPaused = false
      startExpiry()
    }
  }

  function beginClose(kind) {
    if (lifecycle === NotificationEntry.Closing)
      return
    const wasQueued = lifecycle === NotificationEntry.Queued
    closeKind = kind
    lifecycle = NotificationEntry.Closing
    enterTimer.stop()
    expiryTimer.stop()
    timeoutPaused = false
    if (wasQueued || exitDuration === 0)
      finalizeClose()
    else
      exitTimer.restart()
  }

  function finalizeClose() {
    const notification = sourceNotification
    sourceNotification = null
    if (notification !== null) {
      if (closeKind === NotificationEntry.Expired)
        notification.expire()
      else if (closeKind === NotificationEntry.Dismissed)
        notification.dismiss()
    }
    owner.removeEntry(root)
  }
}
