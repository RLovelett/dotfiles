import QtQuick

QtObject {
  property DraculaPalette palette: DraculaPalette {}

  // This preserves the pre-refactor 30% glass recipe. A capsule needs
  // substantially less pigment than a full terminal window for blur to read.
  readonly property real glassSurfaceOpacity: 77 / 255
  readonly property real raisedSurfaceOpacity: 221 / 255
  readonly property color transparent: Qt.rgba(0, 0, 0, 0)
  readonly property color surface: Qt.rgba(palette.background.r, palette.background.g, palette.background.b, glassSurfaceOpacity)
  readonly property color surfaceRaised: Qt.rgba(palette.background.r, palette.background.g, palette.background.b, raisedSurfaceOpacity)
  readonly property color text: palette.foreground
  readonly property color textMuted: palette.comment
  readonly property color outline: palette.selection
  readonly property color divider: palette.selection
  readonly property color track: palette.selection
  readonly property color interactionPressed: palette.selection
  readonly property color interactionHover: surfaceRaised

  readonly property color primary: palette.cyan
  readonly property color secondary: palette.purple
  readonly property color tertiary: palette.pink
  readonly property color success: palette.green
  readonly property color warning: palette.orange
  readonly property color critical: palette.red
  readonly property color highlight: palette.yellow

  readonly property color activeFocused: palette.cyan
  readonly property color activeUnfocused: palette.comment
  readonly property color activeText: palette.background
  readonly property color attention: palette.orange
  readonly property color special: palette.purple
  readonly property color shadow: Qt.rgba(0.12, 0.13, 0.16, 0.4)

  function forRole(role) {
    if (role === SemanticRoles.Muted) return textMuted
    if (role === SemanticRoles.Primary) return primary
    if (role === SemanticRoles.Secondary) return secondary
    if (role === SemanticRoles.Tertiary) return tertiary
    if (role === SemanticRoles.Highlight) return highlight
    if (role === SemanticRoles.Success) return success
    if (role === SemanticRoles.Warning) return warning
    if (role === SemanticRoles.Critical) return critical
    if (role === SemanticRoles.Attention) return attention
    if (role === SemanticRoles.OnAccent) return activeText
    return text
  }
}
