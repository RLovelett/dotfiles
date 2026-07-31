import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.components
import qs.theme

MorphingCapsule {
  id: root

  required property var entry
  required property string appName
  required property string appIcon
  required property string title
  required property string fallbackGlyph

  collapsedWidth: appRow.implicitWidth + theme.metrics.capsulePadding * 2
  expandedWidth: Math.min(theme.metrics.tooltipMaxWidth,
    Math.max(collapsedWidth, titleLabel.implicitWidth + theme.metrics.capsulePadding * 2))
  expandedHeight: theme.metrics.activeAppExpandedHeight
  expandedContentTop: theme.metrics.capsuleHeight

  accentRole: Capsule.Primary
  contentWidth: appRow.implicitWidth

  headerData: RowLayout {
      id: appRow
      anchors.centerIn: parent
      spacing: root.theme.metrics.capsuleGap / 2

    IconImage {
      visible: source !== ""
      source: root.entry !== null ? Quickshell.iconPath(root.appIcon, "application-x-executable") : ""
      implicitSize: root.theme.metrics.workspaceCircleSize
      Layout.preferredWidth: implicitSize
      Layout.preferredHeight: implicitSize
    }

    Symbol {
      visible: root.entry === null
      glyph: root.fallbackGlyph
      tint: root.theme.colors.primary
      theme: root.theme
    }

    StyledText {
      text: root.appName
      theme: root.theme
      textRole: StyledText.Body
      elide: Text.ElideRight
      Layout.maximumWidth: root.theme.metrics.activeAppMaxWidth
    }
  }

  StyledText {
    id: titleLabel
    anchors.fill: parent
    text: root.title
    theme: root.theme
    textRole: StyledText.Body
    tone: SemanticRoles.Muted
    elide: Text.ElideRight
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }
}
