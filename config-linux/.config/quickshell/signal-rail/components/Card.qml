import QtQuick
import QtQuick.Layouts
import qs.theme

Surface {
  id: root

  property int tone: SemanticRoles.Normal
  property int contentPadding: theme.metrics.capsulePadding
  property int contentSpacing: theme.metrics.cardContentSpacing
  property int minimumWidth: 0
  property int maximumWidth: theme.metrics.cardMaxWidth
  default property alias contentData: contentLayout.data

  readonly property real desiredWidth: contentLayout.implicitWidth + contentPadding * 2

  implicitWidth: Math.min(maximumWidth, Math.max(minimumWidth, desiredWidth))
  implicitHeight: contentLayout.implicitHeight + contentPadding * 2
  width: implicitWidth
  height: implicitHeight

  cornerRadius: theme.metrics.cardRadius
  fill: theme.colors.surfaceRaised
  outline: tone === SemanticRoles.Normal ? theme.colors.outline : theme.colors.forRole(tone)

  ColumnLayout {
    id: contentLayout
    x: root.contentPadding
    y: root.contentPadding
    width: root.width - root.contentPadding * 2
    spacing: root.contentSpacing
  }
}
