import QtQuick

QtObject {
  // Canonical screen-edge spacing. Hyprland reads this token as well.
  readonly property int edgeGap: 8

  readonly property int capsuleHeight: 32
  readonly property int capsulePadding: 12
  readonly property int capsuleGap: 12
  readonly property int capsuleTopMargin: edgeGap
  readonly property int capsuleHorizontalMargin: edgeGap
  readonly property int capsuleBorderWidth: 2
  readonly property int railHeight: 40
  readonly property int railLineTopMargin: 24
  readonly property int railLineThickness: 2
  readonly property int iconSize: 18
  readonly property int iconSlotSize: 24
  readonly property int workspaceSlotSize: 27
  readonly property int workspaceCircleSize: 20
  readonly property int dividerWidth: 2
  readonly property int dividerHeight: 18
  readonly property int metricWidth: 64
  readonly property int metricTrackHeight: 2
  readonly property int activeAppMaxWidth: 150
  readonly property int activeAppExpandedHeight: 68
  readonly property int networkStatusWidth: 126
  readonly property int networkNameMaxWidth: 90
  readonly property int tooltipMinWidth: 180
  readonly property int tooltipMaxWidth: 460
  readonly property int tooltipHeight: 34
  readonly property int tooltipGap: 7
  readonly property int cardRadius: 10
  readonly property int cardContentSpacing: 8
  readonly property int cardMaxWidth: 460
  readonly property int actionHeight: 30
  readonly property int actionRadius: 8
  readonly property int clockExpandedWidth: 280
  readonly property int clockHeaderHeight: 22
  readonly property int clockCollapsedFadeOffset: 22
  readonly property int clockExpandedFadeOffset: 28
  readonly property real expandedContentRevealRatio: 0.7
  readonly property int calendarCellWidth: 27
  readonly property int calendarCellHeight: 19
  readonly property int calendarDayDiameter: 19
  readonly property int notificationWidth: 360
  readonly property int notificationIconSize: 40
  readonly property int notificationStackGap: edgeGap
  readonly property int notificationStackLimit: 3
  readonly property int notificationEnterOffset: 16
  readonly property int notificationExitOffset: 12
  readonly property int notificationBodyLineCount: 3
  readonly property real hoverScale: 1.08
  readonly property real attentionScale: 1.12
  readonly property real resourceWarningPercent: 80
  readonly property real resourceCriticalPercent: 95
}
