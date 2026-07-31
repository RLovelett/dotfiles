import QtQuick
import Quickshell
import Quickshell.Io

Scope {
  id: root

  property int urgentWorkspaceId: -1

  IpcHandler {
    target: "workspaces"

    function previewUrgent(workspaceId: int): void {
      root.urgentWorkspaceId = workspaceId
    }

    function clearUrgentPreview(): void {
      root.urgentWorkspaceId = -1
    }
  }
}
