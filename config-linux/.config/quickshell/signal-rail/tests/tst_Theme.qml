import QtQuick
import QtTest
import qs.components
import qs.theme

TestCase {
  name: "Theme"

  Theme { id: rootTheme }

  function test_surfaceAlphaIsDerivedCorrectly() {
    fuzzyCompare(rootTheme.colors.surface.a, 77 / 255, 0.001)
    fuzzyCompare(rootTheme.colors.surfaceRaised.a, 221 / 255, 0.001)
    compare(rootTheme.colors.surface.r, rootTheme.palette.background.r)
    compare(rootTheme.colors.surface.g, rootTheme.palette.background.g)
    compare(rootTheme.colors.surface.b, rootTheme.palette.background.b)
  }

  function test_semanticWorkspaceColors() {
    compare(rootTheme.colors.activeFocused, rootTheme.palette.cyan)
    compare(rootTheme.colors.activeUnfocused, rootTheme.palette.comment)
    compare(rootTheme.colors.attention, rootTheme.palette.orange)
    compare(rootTheme.colors.special, rootTheme.palette.purple)
  }

  function test_semanticRolesResolveForEveryConsumer() {
    compare(rootTheme.colors.forRole(SemanticRoles.Normal), rootTheme.colors.text)
    compare(rootTheme.colors.forRole(SemanticRoles.Muted), rootTheme.colors.textMuted)
    compare(rootTheme.colors.forRole(SemanticRoles.Attention), rootTheme.colors.attention)
    compare(rootTheme.colors.forRole(SemanticRoles.OnAccent), rootTheme.colors.activeText)
  }

  function test_reducedMotionDisablesTokenDurations() {
    rootTheme.reducedMotion = true
    compare(rootTheme.motion.fast, 0)
    compare(rootTheme.motion.barEnter, 0)
    rootTheme.reducedMotion = false
  }

  function test_calendarMarkerFitsItsLayoutSlot() {
    verify(rootTheme.metrics.calendarDayDiameter <= rootTheme.metrics.calendarCellWidth)
    verify(rootTheme.metrics.calendarDayDiameter <= rootTheme.metrics.calendarCellHeight)
  }

  function test_edgeSpacingUsesCanonicalGap() {
    compare(rootTheme.metrics.capsuleTopMargin, rootTheme.metrics.edgeGap)
    compare(rootTheme.metrics.capsuleHorizontalMargin, rootTheme.metrics.edgeGap)
    compare(rootTheme.metrics.notificationStackGap, rootTheme.metrics.edgeGap)
    compare(rootTheme.metrics.railHeight - rootTheme.metrics.capsuleHeight, rootTheme.metrics.edgeGap)
  }

  Component {
    id: capsuleComponent
    Capsule {
      theme: rootTheme
      accentRole: Capsule.Primary
      contentWidth: 40
    }
  }

  function test_capsuleOwnsSizingAndChrome() {
    const capsule = createTemporaryObject(capsuleComponent, this)
    verify(capsule !== null)
    compare(capsule.implicitHeight, rootTheme.metrics.capsuleHeight)
    compare(capsule.implicitWidth, 40 + rootTheme.metrics.capsulePadding * 2)
    compare(capsule.outline, rootTheme.colors.primary)
    compare(capsule.fill, rootTheme.colors.surface)
  }

  function test_capsuleKeepsItsCornerRadiusWhenExpanded() {
    const capsule = createTemporaryObject(capsuleComponent, this)
    verify(capsule !== null)
    const collapsedRadius = capsule.cornerRadius
    capsule.height = rootTheme.metrics.capsuleHeight * 4
    compare(capsule.cornerRadius, collapsedRadius)
    compare(capsule.cornerRadius, rootTheme.metrics.capsuleHeight / 2)
  }
}
