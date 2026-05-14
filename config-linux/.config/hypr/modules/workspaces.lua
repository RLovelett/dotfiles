-- Pin odd workspaces to left monitor (DP-2), even to right (HDMI-A-1)
for workspace = 1, 10 do
  local monitor = "DP-2"
  local default = false
  if workspace == 1 or workspace == 2 then
    default = true
  end
  if workspace % 2 == 0 then
    monitor = "HDMI-A-1"
  end
  hl.workspace_rule({ workspace = tostring(workspace), monitor = monitor, default = default })
end
