import QtQuick
import QtTest
import "../features/clock/DateUtils.js" as DateUtils

TestCase {
  name: "DateUtils"

  function test_calendarCellsAlwaysBuildsSixWeeks() {
    const cells = DateUtils.calendarCells(new Date(2026, 7, 3))
    compare(cells.length, 42)
    compare(cells[6], 1)
    compare(cells[8], 3)
    compare(cells[36], 31)
  }

  function test_isoWeekAcrossYearBoundary() {
    compare(DateUtils.isoWeek(new Date(2026, 0, 1)), 1)
    compare(DateUtils.isoWeek(new Date(2026, 7, 3)), 32)
  }

  function test_twelveHourTime() {
    compare(DateUtils.twelveHourTime(new Date(2026, 7, 3, 0, 5, 9), false), "12:05")
    compare(DateUtils.twelveHourTime(new Date(2026, 7, 3, 13, 5, 9), true), "1:05:09")
  }
}
