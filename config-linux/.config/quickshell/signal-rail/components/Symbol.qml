import QtQuick
import qs.theme

Text {
  required property Theme theme
  property string glyph: ""
  property color tint: theme.colors.text
  property int pointSize: theme.type.symbol
  property int slotSize: theme.metrics.iconSlotSize

  text: glyph
  color: tint
  width: slotSize
  height: slotSize
  font.family: theme.type.symbolFamily
  font.pixelSize: pointSize
  font.weight: theme.type.regularWeight
  renderType: Text.NativeRendering
  horizontalAlignment: Text.AlignHCenter
  verticalAlignment: Text.AlignVCenter
}
