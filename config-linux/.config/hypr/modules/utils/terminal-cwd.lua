--- terminal-cwd.lua
--- Provides a utility for resolving the current working directory of the
--- active terminal window in Hyprland, including support for tmux sessions
--- and foreground processes (e.g. nvim, git).
---
--- Usage:
---   local terminal_cwd = require("modules/util/terminal-cwd")
---   local cwd = terminal_cwd.get()
---
--- @module terminal-cwd

local M = {}

--- Returns a list of PIDs whose parent matches the given PID.
--- Scans /proc/<pid>/status for each running process and checks the PPid field.
--- This is equivalent to `pgrep -P <parent_pid>`.
--- @param parent_pid number The parent PID to search for.
--- @return table A (possibly empty) list of child PIDs as numbers.
local function pgrep_ppid(parent_pid)
  local children = {}
  local target = tostring(parent_pid)

  local handle = io.popen("ls /proc")
  if handle == nil then
    return {}
  end

  for entry in handle:lines() do
    local pid = tonumber(entry)
    if pid then
      local f = io.open("/proc/" .. entry .. "/status", "r")
      if f then
        for line in f:lines() do
          local ppid = line:match("^PPid:%s*(%d+)")
          if ppid == target then
            table.insert(children, pid)
            break
          end
        end
        f:close()
      end
    end
  end

  handle:close()
  return children
end

--- Returns the resolved executable path of a process via /proc/<pid>/exe.
--- Equivalent to `readlink -f /proc/<pid>/exe`.
--- @param pid number The PID to query.
--- @return string|nil The resolved executable path, or nil if unreadable.
local function get_exe(pid)
  local handle = io.popen("readlink -f /proc/" .. pid .. "/exe 2>/dev/null")
  if handle == nil then
    return nil
  end
  local exe = handle:read("*l")
  handle:close()
  return exe
end

--- Returns the resolved current working directory of a process via /proc/<pid>/cwd.
--- Equivalent to `readlink -f /proc/<pid>/cwd`.
--- @param pid number The PID to query.
--- @return string|nil The resolved cwd path, or nil if unreadable.
local function get_cwd(pid)
  local handle = io.popen("readlink -f /proc/" .. pid .. "/cwd 2>/dev/null")
  if handle == nil then
    return nil
  end
  local cwd = handle:read("*l")
  handle:close()
  return cwd
end

--- Returns the PID of the shell running in the currently active tmux pane.
--- Queries the tmux server over its IPC socket using `tmux display-message`.
--- Should only be called when the active child process is known to be tmux.
--- @return number|nil The shell PID of the active tmux pane, or nil if tmux is unreachable.
local function get_tmux_pane_pid()
  local handle = io.popen("tmux display-message -p '#{pane_pid}' 2>/dev/null")
  if handle == nil then
    return nil
  end
  local pid = handle:read("*l")
  handle:close()
  return tonumber(pid)
end

--- Resolves the current working directory of the active terminal window.
---
--- Resolution order:
---   1. Gets the active Hyprland window and its PID.
---   2. Finds the child process of the terminal (the shell or tmux client).
---   3. If the child is tmux, asks tmux for the active pane's shell PID.
---   4. Prefers the cwd of any foreground process running inside the shell
---      (e.g. nvim, git), so the new terminal opens in the same directory.
---   5. Falls back to the shell's own cwd.
---   6. Falls back to $HOME if nothing can be resolved.
---
--- @return string The resolved cwd path, or $HOME as a fallback.
function M.get()
  local home = os.getenv("HOME") or "/"

  local w = hl.get_active_window()
  if w == nil then
    return home
  end

  local terminal_pid = w.pid
  local children = pgrep_ppid(terminal_pid)
  local child_pid = children[#children]

  if child_pid == nil then
    return home
  end

  local child_exe = get_exe(child_pid)

  local shell_pid = child_pid
  if child_exe and child_exe:match(".*/tmux.*") then
    shell_pid = get_tmux_pane_pid()
  end

  if shell_pid == nil then
    return home
  end

  -- Prefer the cwd of the foreground process running inside the shell
  local cwd = nil
  local fg_children = pgrep_ppid(shell_pid)
  local fg_pid = fg_children[#fg_children]
  if fg_pid then
    cwd = get_cwd(fg_pid)
  end

  -- Fall back to the shell's own cwd
  if cwd == nil or cwd == "" then
    cwd = get_cwd(shell_pid)
  end

  if cwd and cwd ~= "" then
    return cwd
  else
    return home
  end
end

return M
