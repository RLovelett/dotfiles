import QtQuick
import QtQuick.Layouts
import qs.components
import qs.theme
import "DateUtils.js" as DateUtils

ColumnLayout {
  id: root

  required property Theme theme
  required property date date

  spacing: theme.metrics.capsuleGap * 2 / 3

  StyledText {
    text: `${Qt.formatDateTime(root.date, "MMMM yyyy")}  ·  week ${DateUtils.isoWeek(root.date)}`
    tone: SemanticRoles.Secondary
    theme: root.theme
    textRole: StyledText.Label
  }

  GridLayout {
    id: calendarGrid

    columns: 7
    columnSpacing: root.theme.metrics.capsuleGap / 4
    rowSpacing: root.theme.metrics.capsuleGap / 4
    Layout.alignment: Qt.AlignHCenter

    Repeater {
      model: ["S", "M", "T", "W", "T", "F", "S"]
      StyledText {
        required property string modelData
        text: modelData
        tone: SemanticRoles.Muted
        theme: root.theme
        textRole: StyledText.LabelSmall
        horizontalAlignment: Text.AlignHCenter
        Layout.preferredWidth: root.theme.metrics.calendarCellWidth
      }
    }

    Repeater {
      model: DateUtils.calendarCells(root.date)
      Item {
        id: dayCell

        required property int modelData
        readonly property bool today: modelData === root.date.getDate()
        Layout.preferredWidth: root.theme.metrics.calendarCellWidth
        Layout.preferredHeight: root.theme.metrics.calendarCellHeight

        Rectangle {
          anchors.centerIn: parent
          width: root.theme.metrics.calendarDayDiameter
          height: width
          radius: width / 2
          color: dayCell.today ? root.theme.colors.secondary : root.theme.colors.transparent

          StyledText {
            anchors.fill: parent
            text: dayCell.modelData === 0 ? "" : dayCell.modelData
            tone: dayCell.today ? SemanticRoles.OnAccent : SemanticRoles.Normal
            theme: root.theme
            textRole: StyledText.LabelSmall
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
          }
        }
      }
    }
  }
}
