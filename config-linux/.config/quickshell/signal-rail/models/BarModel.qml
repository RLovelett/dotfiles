import QtQuick
import Quickshell
import Quickshell.Hyprland

QtObject {
  id: root

  required property var screen

  readonly property var monitor: Hyprland.monitorFor(screen)
  readonly property bool monitorFocused: monitor !== null && monitor.focused
  readonly property bool monitorFullscreen: monitor !== null
    && monitor.activeWorkspace !== null
    && monitor.activeWorkspace.hasFullscreen

  readonly property var visibleWorkspaces: {
    if (monitor === null)
      return []
    return Hyprland.workspaces.values
      .filter(workspace => workspace.id > 0
        && workspace.monitor !== null
        && workspace.monitor.name === monitor.name
        && (workspace.active || workspace.toplevels.values.length > 0))
      .sort((a, b) => a.id - b.id)
  }

  readonly property var scratchpad: Hyprland.workspaces.values.find(workspace =>
    workspace.name === "special:scratchpad"
      && workspace.monitor !== null
      && monitor !== null
      && workspace.monitor.name === monitor.name
      && (workspace.active || workspace.toplevels.values.length > 0)) || null

  readonly property var activeWorkspaceToplevels: monitor !== null && monitor.activeWorkspace !== null
    ? monitor.activeWorkspace.toplevels.values
    : []
  readonly property var workspaceFallbackToplevel: {
    if (activeWorkspaceToplevels.length === 0)
      return null
    return activeWorkspaceToplevels.reduce((best, candidate) => {
      const candidateRank = candidate.lastIpcObject.focusHistoryID ?? Number.MAX_SAFE_INTEGER
      const bestRank = best.lastIpcObject.focusHistoryID ?? Number.MAX_SAFE_INTEGER
      return candidateRank < bestRank ? candidate : best
    })
  }
  // The global active toplevel can be null during initial Hyprland synchronization.
  readonly property var activeToplevel: monitorFocused
    ? Hyprland.activeToplevel || workspaceFallbackToplevel
    : null
  readonly property string activeClass: {
    if (activeToplevel === null)
      return ""
    if (activeToplevel.wayland !== null && activeToplevel.wayland.appId !== "")
      return activeToplevel.wayland.appId
    return activeToplevel.lastIpcObject.class || activeToplevel.lastIpcObject.initialClass || ""
  }
  readonly property var activeEntry: activeClass === "" ? null : DesktopEntries.heuristicLookup(activeClass)
  readonly property string activeAppName: activeEntry !== null ? activeEntry.name : humanize(activeClass)
  readonly property string activeAppIcon: activeEntry !== null && activeEntry.icon !== ""
    ? activeEntry.icon
    : "application-x-executable"
  readonly property string activeTitle: activeToplevel === null
    ? ""
    : activeToplevel.lastIpcObject.title || activeAppName

  function humanize(value) {
    if (!value)
      return "Desktop"
    const base = value.split(".").pop().replace(/[-_]/g, " ")
    return base.charAt(0).toUpperCase() + base.slice(1)
  }
}
