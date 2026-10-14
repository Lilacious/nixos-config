-- Bold name of the focused app, like the app menu title next to the Apple logo.
-- Clicking it opens the app menu. Follows niri's event stream (on Hyprland: menubar-wm
-- hypr-watch) and shows the active window of the focused workspace: unlike the focused
-- window, it stays put while a menu or panel holds keyboard focus. On an empty workspace
-- it says "Finder", as macOS does when nothing else is frontmost.

local pillHeight = require("./lib/pill.luau").height()
local Wm = require("./lib/wm.luau")

local windows = {} -- window id -> niri window
local frontmost = nil -- Hyprland: the frontmost window, shaped like a niri window
local workspaces = {} -- workspace id -> { focused, activeWindowId }
local names = {} -- app id -> display name (false while the lookup runs)
local wm = noctalia.pluginDir() .. "/bin/menubar-wm"
local appName = ""
local menuOpen = false

-- drawn exactly like the bar's other items (noctalia's full-round capsule; text and padding at the kit's x 0.88),
-- lit with a pill while the app menu is open
function draw()
  barWidget.render(ui.row({
    height = pillHeight, -- noctalia's capsule: bar thickness x capsule_thickness
    paddingH = 8, -- kit padding x 0.88
    radius = pillHeight / 2, -- fully round
    align = "center",
    -- always set a fill: dropping the prop does not clear the old one
    fill = menuOpen and "on_surface/0.1" or "#00000000", -- = noctalia's hover pill (on_surface at 10%)
  }, {
    ui.label({ text = appName, fontWeight = "bold" }),
  }))
end

noctalia.state.watch("menuOpen", function(menu)
  menuOpen = menu == "app"
  draw()
end)

-- com.mitchellh.ghostty -> Ghostty, until the desktop entry has been looked up
local function prettify(appId)
  local last = string.match(appId, "([^%.]+)$") or appId
  return (string.gsub(last, "^%l", string.upper))
end

local function activeWindow()
  if Wm.hyprland then
    return frontmost
  end
  for _, workspace in pairs(workspaces) do
    if workspace.focused then
      return workspace.activeWindowId and windows[workspace.activeWindowId]
    end
  end
  return nil
end

local function render()
  local window = activeWindow()
  if not window or not window.app_id then
    noctalia.state.set("focused", nil)
    appName = "Finder"
    barWidget.setVisible(true)
    draw()
    barWidget.setTooltip("")
    return
  end
  local appId = window.app_id
  if names[appId] == nil then
    names[appId] = false
    noctalia.runAsync({ wm, "app-info", appId }, function(result)
      local info = noctalia.json.decode(result.stdout or "")
      names[appId] = (info and info.name) or prettify(appId)
      render()
    end)
  end
  local name = names[appId] or prettify(appId)
  appName = name
  noctalia.state.set("focused", {
    id = window.id,
    appId = appId,
    name = name,
    title = window.title or "",
    pid = window.pid or 0,
    workspaceId = window.workspace_id or 0,
    floating = window.is_floating == true,
  })
  barWidget.setVisible(true)
  draw()
  barWidget.setTooltip(window.title)
end

local function remember(window)
  windows[window.id] = window
end

local function onEvent(line)
  local event = noctalia.json.decode(line)
  if type(event) ~= "table" then
    return
  end
  if event.WorkspacesChanged then
    workspaces = {}
    for _, w in ipairs(event.WorkspacesChanged.workspaces) do
      workspaces[w.id] = { focused = w.is_focused, activeWindowId = w.active_window_id }
    end
  elseif event.WorkspaceActivated then
    local e = event.WorkspaceActivated
    if e.focused then
      for id, w in pairs(workspaces) do
        w.focused = id == e.id
      end
    end
  elseif event.WorkspaceActiveWindowChanged then
    local e = event.WorkspaceActiveWindowChanged
    if workspaces[e.workspace_id] then
      workspaces[e.workspace_id].activeWindowId = e.active_window_id
    end
  elseif event.WindowsChanged then
    windows = {}
    for _, window in ipairs(event.WindowsChanged.windows) do
      remember(window)
    end
  elseif event.WindowOpenedOrChanged then
    remember(event.WindowOpenedOrChanged.window)
  elseif event.WindowClosed then
    windows[event.WindowClosed.id] = nil
  else
    return
  end
  render()
end

function onClick()
  -- no app menu for "Finder": it would fall back to a window on another workspace
  if noctalia.state.get("focused") == nil then
    return
  end
  noctalia.togglePanel("yunix/menubar:app-menu")
end

-- one JSON line per change: the frontmost window, or null
local function onHyprland(line)
  local window = noctalia.json.decode(line)
  frontmost = type(window) == "table" and window or nil
  render()
end

barWidget.setVisible(false)
if Wm.hyprland then
  -- runStream takes a command line, not an argv list
  noctalia.runStream(wm .. " hypr-watch", onHyprland)
else
  noctalia.runStream("niri msg --json event-stream", onEvent)
end
