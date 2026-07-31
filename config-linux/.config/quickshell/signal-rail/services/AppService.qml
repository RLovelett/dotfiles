import QtQuick
import Quickshell
import Quickshell.Hyprland

QtObject {
  function focusOrLaunchTui(command, unblock) {
    const appId = `me.lovelett.hyprland.${command}`
    const existing = Hyprland.toplevels.values.find(toplevel =>
      (toplevel.lastIpcObject.class || "") === appId)

    if (existing !== undefined) {
      Hyprland.dispatch(`focuswindow class:^${appId}$`)
      return
    }

    if (unblock !== "")
      Quickshell.execDetached(["rfkill", "unblock", unblock])
    Quickshell.execDetached(["uwsm", "app", "--", "xdg-terminal-exec", `--app-id=${appId}`, "-e", command])
  }
}
