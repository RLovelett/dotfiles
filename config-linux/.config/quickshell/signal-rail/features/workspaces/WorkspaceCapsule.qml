import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.components
import qs.theme

Capsule {
  id: root

  required property var workspaces
  required property var scratchpad
  required property bool monitorFocused
  property int urgencyPreviewWorkspaceId: -1

  accentRole: Capsule.Primary
  contentWidth: workspaceRow.implicitWidth

  RowLayout {
    id: workspaceRow
    anchors.centerIn: parent
    spacing: root.theme.metrics.capsuleGap / 3

    Repeater {
      model: ScriptModel { values: root.workspaces }

      WorkspaceIndicator {
        required property var modelData
        theme: root.theme
        label: modelData.name
        active: modelData.active
        focused: modelData.focused
        urgent: modelData.urgent === true || root.urgencyPreviewWorkspaceId === modelData.id
        onActivated: modelData.activate()
      }
    }

    WorkspaceIndicator {
      visible: root.scratchpad !== null
      theme: root.theme
      label: "󰘔"
      special: true
      active: root.scratchpad !== null && root.scratchpad.active
      focused: active && root.monitorFocused
      urgent: root.scratchpad !== null && root.scratchpad.urgent === true
      onActivated: Hyprland.dispatch("togglespecialworkspace scratchpad")
    }
  }
}
