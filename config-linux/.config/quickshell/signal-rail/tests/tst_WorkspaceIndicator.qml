import QtQuick
import QtTest
import qs.features.workspaces
import qs.theme

TestCase {
  name: "WorkspaceIndicator"

  Theme { id: rootTheme }
  WorkspaceIndicator {
    id: indicator
    theme: rootTheme
    label: "3"
  }

  function init() {
    indicator.active = false
    indicator.focused = false
    indicator.urgent = false
    indicator.special = false
  }

  function test_occupiedInactiveIsHollow() {
    compare(indicator.fillColor, rootTheme.colors.transparent)
    compare(indicator.outlineColor, rootTheme.colors.outline)
  }

  function test_activeUnfocusedUsesMutedFill() {
    indicator.active = true
    compare(indicator.fillColor, rootTheme.colors.activeUnfocused)
    compare(indicator.outlineColor, rootTheme.colors.activeUnfocused)
  }

  function test_activeFocusedUsesCyanFill() {
    indicator.active = true
    indicator.focused = true
    compare(indicator.fillColor, rootTheme.colors.activeFocused)
    compare(indicator.outlineColor, rootTheme.colors.activeFocused)
  }

  function test_urgencyOverlaysInactiveState() {
    indicator.urgent = true
    compare(indicator.fillColor, rootTheme.colors.transparent)
    compare(indicator.outlineColor, rootTheme.colors.attention)
  }

  function test_urgencyPreservesActiveFill() {
    indicator.active = true
    indicator.urgent = true
    compare(indicator.fillColor, rootTheme.colors.activeUnfocused)
    compare(indicator.outlineColor, rootTheme.colors.attention)
  }

  function test_specialStates() {
    indicator.special = true
    compare(indicator.fillColor, rootTheme.colors.transparent)
    compare(indicator.outlineColor, rootTheme.colors.special)
    indicator.active = true
    compare(indicator.fillColor, rootTheme.colors.special)
    indicator.urgent = true
    compare(indicator.fillColor, rootTheme.colors.special)
    compare(indicator.outlineColor, rootTheme.colors.attention)
  }
}
