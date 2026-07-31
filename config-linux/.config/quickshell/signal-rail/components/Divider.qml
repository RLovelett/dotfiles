import QtQuick
import QtQuick.Layouts
import qs.theme

Rectangle {
  required property Theme theme
  Layout.preferredWidth: theme.metrics.dividerWidth
  Layout.preferredHeight: theme.metrics.dividerHeight
  color: theme.colors.divider
}
