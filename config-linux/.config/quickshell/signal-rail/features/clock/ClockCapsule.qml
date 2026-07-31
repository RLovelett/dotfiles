import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components
import qs.theme
import "DateUtils.js" as DateUtils

MorphingCapsule {
  id: root

  required property string clockGlyph
  readonly property color clockAccent: theme.colors.secondary
  readonly property real calendarContentHeight: calendarContent.implicitHeight
  collapsedWidth: collapsedHeader.implicitWidth + theme.metrics.capsulePadding * 2
  expandedWidth: theme.metrics.clockExpandedWidth
  expandedHeight: theme.metrics.tooltipHeight
    + calendarContentHeight
    + theme.metrics.capsulePadding
  expandedContentTop: theme.metrics.tooltipHeight

  accentRole: Capsule.Secondary
  contentWidth: collapsedHeader.implicitWidth

  SystemClock {
    id: clock
    precision: root.expanded ? SystemClock.Seconds : SystemClock.Minutes
  }

  headerData: [
    RowLayout {
      id: collapsedHeader
      anchors.centerIn: parent
      height: root.theme.metrics.clockHeaderHeight
      spacing: root.theme.metrics.capsuleGap / 2
      opacity: !root.expanded || root.width < root.expandedWidth - root.theme.metrics.clockCollapsedFadeOffset ? 1 : 0

      Behavior on opacity { MotionAnimation { theme: root.theme; motionRole: MotionAnimation.Fast } }

    Symbol {
      glyph: root.clockGlyph
      tint: root.clockAccent
      theme: root.theme
    }
    StyledText {
      text: DateUtils.twelveHourTime(clock.date, false)
      theme: root.theme
      textRole: StyledText.Title
    }
    StyledText {
      text: `${Qt.formatDateTime(clock.date, "AP")} · ${Qt.formatDateTime(clock.date, "ddd, d MMM")}`
      tone: SemanticRoles.Muted
      theme: root.theme
      textRole: StyledText.Label
    }
    },

    RowLayout {
      anchors.centerIn: parent
      height: root.theme.metrics.clockHeaderHeight
      spacing: root.theme.metrics.capsuleGap / 2
      opacity: root.expanded && root.width >= root.expandedWidth - root.theme.metrics.clockExpandedFadeOffset ? 1 : 0

      Behavior on opacity { MotionAnimation { theme: root.theme; motionRole: MotionAnimation.Fast } }

    Symbol {
      glyph: root.clockGlyph
      tint: root.clockAccent
      theme: root.theme
    }
    StyledText {
      text: DateUtils.twelveHourTime(clock.date, true)
      theme: root.theme
      textRole: StyledText.Title
    }
    StyledText {
      text: `${Qt.formatDateTime(clock.date, "AP")} · ${Qt.formatDateTime(clock.date, "ddd, d MMM")} · ${Qt.formatDateTime(clock.date, "HH:mm")}`
      tone: SemanticRoles.Muted
      theme: root.theme
      textRole: StyledText.Label
    }
    }
  ]

  CalendarContent {
    id: calendarContent

    anchors.fill: parent
    date: clock.date
    theme: root.theme
  }
}
