.pragma library

function calendarCells(date) {
  const year = date.getFullYear()
  const month = date.getMonth()
  const firstDay = new Date(year, month, 1).getDay()
  const days = new Date(year, month + 1, 0).getDate()
  const cells = []
  for (let i = 0; i < 42; ++i) {
    const day = i - firstDay + 1
    cells.push(day > 0 && day <= days ? day : 0)
  }
  return cells
}

function isoWeek(date) {
  const value = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()))
  value.setUTCDate(value.getUTCDate() + 4 - (value.getUTCDay() || 7))
  const start = new Date(Date.UTC(value.getUTCFullYear(), 0, 1))
  return Math.ceil((((value - start) / 86400000) + 1) / 7)
}

function twelveHourTime(date, withSeconds) {
  const hour = ((date.getHours() + 11) % 12) + 1
  const minute = String(date.getMinutes()).padStart(2, "0")
  const second = String(date.getSeconds()).padStart(2, "0")
  return withSeconds ? `${hour}:${minute}:${second}` : `${hour}:${minute}`
}
