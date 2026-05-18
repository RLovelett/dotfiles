--- launcher.lua
--- Provides utilities for focusing an existing window or launching a new one,
--- with additional support for TUI applications launched in a terminal and
--- browser launching with automatic private-mode flag detection.
---
--- Usage:
---   local launcher = require("modules.utils.launcher")
---   launcher.launch_or_focus("class:^signal$", "uwsm app -- signal-desktop")
---   launcher.tui("bluetui")
---   launcher.tui("fastfetch", {
---     cmd = 'bash -c "fastfetch; read -rsp $\'\\nPress any key to close...\' -n1"'
---   })
---   launcher.launch_browser()
---   launcher.launch_browser({ private = true })
---
--- @module launcher

local M = {}

--- Focuses an existing window matching the given selector, or launches a command if none is found.
---
--- Useful for keeping only one instance of an application open at a time. If a matching
--- window already exists on any workspace, focus switches to it immediately. If no match
--- is found, the launch command is executed to start a new instance.
---
--- The window selector follows Hyprland's window addressing syntax, e.g.:
---   "class:^signal$"  -- match by window class (regex)
---   "title:Obsidian"  -- match by window title
---
--- Example:
---   launcher.launch_or_focus("class:^signal$", "uwsm app -- signal-desktop")
---
--- @param window_selector string A Hyprland window selector string used to find an existing window.
--- @param launch_cmd string The shell command to execute if no matching window is found.
--- @return nil
function M.launch_or_focus(window_selector, launch_cmd)
  local w = hl.get_window(window_selector)
  if w ~= nil then
    hl.dispatch(hl.dsp.focus({ window = w }))
  else
    hl.dispatch(hl.dsp.exec_cmd(launch_cmd))
  end
end

--- Focuses an existing TUI window or launches it in a new terminal.
---
--- The app ID is derived from the TUI command name as `me.lovelett.hyprland.<tui_cmd>`,
--- and is passed to `xdg-terminal-exec --app-id` so the window has a stable, known class
--- that can be matched on subsequent calls.
---
--- Options:
---   opts.app_id  Override the derived app ID (e.g. for a custom class name).
---   opts.cmd     Override the command passed to `-e` in the terminal (e.g. for
---                wrapped bash invocations like `bash -c "cmd; read ..."`).
---
--- Examples:
---   -- Simple TUI, all defaults derived from command name:
---   launcher.tui("bluetui")
---
---   -- Wrapped TUI that needs to stay open after exit:
---   launcher.tui("fastfetch", {
---     cmd = 'bash -c "fastfetch; read -rsp $\'\\nPress any key to close...\' -n1"'
---   })
---
---   -- Custom app ID override:
---   launcher.tui("nvim", { app_id = "me.lovelett.hyprland.editor" })
---
--- @param tui_cmd string The TUI command name, used to derive the app ID and launch command.
--- @param opts? { app_id?: string, cmd?: string } Optional overrides.
--- @return nil
function M.tui(tui_cmd, opts)
  opts = opts or {}

  local app_id = opts.app_id or ("me.lovelett.hyprland." .. tui_cmd)
  local cmd = opts.cmd or tui_cmd

  local launch_cmd = "uwsm app -- xdg-terminal-exec --app-id=" .. app_id .. " -e " .. cmd

  M.launch_or_focus("class:^" .. app_id .. "$", launch_cmd)
end

--- Resolves the executable path for the system default browser.
--- Reads the .desktop file from ~/.local/share/applications or /usr/share/applications
--- and extracts the Exec= field.
--- @return string|nil The resolved browser executable path, or nil if not found.
local function resolve_browser_exec()
  local handle = io.popen("xdg-settings get default-web-browser 2>/dev/null")
  if handle == nil then
    return nil
  end
  local desktop_file = handle:read("*l")
  handle:close()

  if desktop_file == nil or desktop_file == "" then
    return nil
  end

  local search_dirs = {
    os.getenv("HOME") .. "/.local/share/applications/",
    "/usr/share/applications/",
  }

  for _, dir in ipairs(search_dirs) do
    local f = io.open(dir .. desktop_file, "r")
    if f then
      for line in f:lines() do
        local exec = line:match("^Exec=(%S+)")
        if exec then
          f:close()
          return exec
        end
      end
      f:close()
    end
  end

  return nil
end

--- Detects the private browsing flag for the given browser executable by name.
--- Gecko-based browsers (Firefox, LibreWolf, Zen) use --private-window,
--- Edge uses --inprivate, and everything else (Chromium, Chrome, Brave)
--- defaults to --incognito.
--- @param browser_exec string The resolved browser executable path.
--- @return string The appropriate private browsing flag.
local function resolve_private_flag(browser_exec)
  if browser_exec:find("firefox", 1, true)
  or browser_exec:find("librewolf", 1, true)
  or browser_exec:find("zen", 1, true) then
    return "--private-window"
  end

  if browser_exec:find("edge", 1, true) then
    return "--inprivate"
  end

  return "--incognito"
end

--- Launches the system default browser, with optional private browsing mode.
---
--- The default browser is determined via `xdg-settings get default-web-browser`.
--- The correct private browsing flag is detected automatically:
---   - Gecko-based (Firefox, LibreWolf): --private-window
---   - Edge:                             --inprivate
---   - Chromium-based (default):         --incognito
---
--- Examples:
---   launcher.browser()
---   launcher.browser({ private = true })
---
--- @param opts? { private?: boolean } Optional options table.
--- @return nil
function M.browser(opts)
  opts = opts or {}

  local browser_exec = resolve_browser_exec()
  if browser_exec == nil then
    hl.notification.create({ text = "launcher: could not resolve default browser", timeout = 5000, icon = 3 })
    return
  end

  local cmd = "uwsm app -- " .. browser_exec
  if opts.private then
    cmd = cmd .. " " .. resolve_private_flag(browser_exec)
  end

  hl.dispatch(hl.dsp.exec_cmd(cmd))
end

return M
