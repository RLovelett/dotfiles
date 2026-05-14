-- Only display the OSD on the currently focused monitor.
-- Returns a function (dispatcher) that resolves the monitor name at invocation time,
-- not at config load time, so focus changes between binds are reflected correctly.
local function osdclient(args)
  return function()
    local monitor = hl.get_active_monitor()
    if monitor then
      hl.dispatch(hl.dsp.exec_cmd("swayosd-client --monitor " .. monitor.name .. " " .. args))
    end
  end
end

-- Volume and LCD brightness (repeat + locked)
hl.bind(
  "XF86AudioRaiseVolume",
  osdclient("--output-volume raise"),
  { repeating = true, locked = true, description = "Volume up" }
)
hl.bind(
  "XF86AudioLowerVolume",
  osdclient("--output-volume lower"),
  { repeating = true, locked = true, description = "Volume down" }
)
hl.bind(
  "XF86AudioMute",
  osdclient("--output-volume mute-toggle"),
  { repeating = true, locked = true, description = "Mute" }
)
hl.bind(
  "XF86AudioMicMute",
  osdclient("--input-volume mute-toggle"),
  { repeating = true, locked = true, description = "Mute microphone" }
)
-- hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("omarchy-brightness-display +5%"),            { repeating = true, locked = true, description = "Brightness up" })
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("omarchy-brightness-display 5%-"),            { repeating = true, locked = true, description = "Brightness down" })
-- hl.bind("XF86KbdBrightnessUp",   hl.dsp.exec_cmd("omarchy-brightness-keyboard up"),            { repeating = true, locked = true, description = "Keyboard brightness up" })
-- hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("omarchy-brightness-keyboard down"),          { repeating = true, locked = true, description = "Keyboard brightness down" })
-- hl.bind("XF86KbdLightOnOff",     hl.dsp.exec_cmd("omarchy-brightness-keyboard cycle"),         {                  locked = true, description = "Keyboard backlight cycle" })

-- Precise 1% adjustments with Alt modifier (repeat + locked)
hl.bind(
  "ALT + XF86AudioRaiseVolume",
  osdclient("--output-volume +1"),
  { repeating = true, locked = true, description = "Volume up precise" }
)
hl.bind(
  "ALT + XF86AudioLowerVolume",
  osdclient("--output-volume -1"),
  { repeating = true, locked = true, description = "Volume down precise" }
)
-- hl.bind("ALT + XF86MonBrightnessUp",   hl.dsp.exec_cmd("omarchy-brightness-display +1%"),    { repeating = true, locked = true, description = "Brightness up precise" })
-- hl.bind("ALT + XF86MonBrightnessDown", hl.dsp.exec_cmd("omarchy-brightness-display 1%-"),    { repeating = true, locked = true, description = "Brightness down precise" })

-- Playerctl (locked, no repeat)
hl.bind("XF86AudioNext", osdclient("--playerctl next"), { locked = true, description = "Next track" })
hl.bind("XF86AudioPause", osdclient("--playerctl play-pause"), { locked = true, description = "Pause" })
hl.bind("XF86AudioPlay", osdclient("--playerctl play-pause"), { locked = true, description = "Play" })
hl.bind("XF86AudioPrev", osdclient("--playerctl previous"), { locked = true, description = "Previous track" })

-- Switch audio output with Super + Mute
-- hl.bind("SUPER + XF86AudioMute", hl.dsp.exec_cmd("omarchy-cmd-audio-switch"), { locked = true, description = "Switch audio output" })
