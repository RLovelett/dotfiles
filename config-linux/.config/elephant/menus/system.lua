Name = "system"
NamePretty = "system"
FixedOrder = true
HideFromProviderlist = false
Cache = false

Actions = {
  activate = "lua:Run",
}

function Run(value)
  os.execute(value)
end

function GetEntries()
  return {
    { Text = "Lock screen", Subtext = "hyprlock", Value = "hyprlock", Icon = "system-lock-screen" },
    {
      Text = "Suspend",
      Subtext = "systemctl suspend",
      Value = "systemctl suspend",
      Icon = "media-playback-pause",
    },
    { Text = "Reboot", Subtext = "systemctl reboot", Value = "systemctl reboot", Icon = "system-reboot" },
    { Text = "Shut down", Subtext = "systemctl poweroff", Value = "systemctl poweroff", Icon = "system-shutdown" },
    { Text = "Log out", Subtext = "uwsm stop", Value = "uwsm stop", Icon = "system-log-out" },
  }
end
