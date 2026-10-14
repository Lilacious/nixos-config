-- App menu for the focused app, opened from its bold name: the app menu and the
-- Window menu of macOS in one dropdown; shortcuts are read from the niri or Hyprland
-- config. Neither has hidden or minimized windows, so there is no Hide or Minimize.

local Binds = require("./lib/binds.luau")
local Alert = require("./lib/alert.luau")
local Wm = require("./lib/wm.luau")

local wm = noctalia.pluginDir() .. "/bin/menubar-wm"
local view = "menu" -- menu | about | confirm
local hovered = nil
local binds = {}
local app = nil -- focused window as published by the app widget
local info = nil -- app-info result

---------------------------------------------------------------- data

local function loadInfo()
  info = nil
  noctalia.runAsync({ wm, "app-info", app.appId, tostring(app.pid) }, function(result)
    info = noctalia.json.decode(result.stdout or "")
    if app and info and info.name then
      app.name = info.name
    end
    render()
  end)
end

local function shortcut(...)
  return Binds.find(binds, { ... })
end

---------------------------------------------------------------- actions

local function run(argv)
  panel.close()
  noctalia.runAsync(argv)
end

-- niri actions on this exact window (the panel may hold keyboard focus)
local function onWindow(...)
  local args = { ... }
  table.insert(args, "--id")
  table.insert(args, tostring(app.id))
  run({ "niri", "msg", "action", table.unpack(args) })
end

-- actions without an id flag: focus the window first
local function focusThen(niriAction)
  run({ "sh", "-c", "niri msg action focus-window --id " .. app.id .. " && niri msg action " .. niriAction })
end

-- Hyprland: a dispatcher on this exact window. With hyprland.lua, hyprctl dispatch takes
-- an hl.dsp call; `fields` are its other table fields, e.g. 'mode = "maximized"'
local function onHyprland(dispatcher, fields)
  local window = 'window = "address:' .. app.id .. '"'
  run({ "hyprctl", "dispatch", dispatcher .. "({ " .. (fields and (fields .. ", ") or "") .. window .. " })" })
end

local function show(next)
  view, hovered = next, nil
  render()
end

---------------------------------------------------------------- hover

function onRowHover(state, key)
  local next = hovered
  if state == "true" then
    next = key
  elseif hovered == key then
    next = nil
  end
  if next ~= hovered then
    hovered = next
    render()
  end
end

function onMenuHover(state)
  if state == "false" and hovered ~= nil then
    hovered = nil
    render()
  end
end

---------------------------------------------------------------- views

-- a disabled row is greyed out and ignores clicks, like macOS menu items
local function row(key, text, right, onClick, check, disabled)
  local active = hovered == key and not disabled
  local color = disabled and "on_surface/0.3" or "on_surface"
  return ui.row({
    key = key,
    height = 24,
    paddingH = 3, -- + noctalia 13 = macOS 16pt inset
    gap = 6,
    radius = 7, -- macOS 27 hover pill
    align = "center",
    -- always set a fill: dropping the prop does not clear the old one
    fill = active and "primary" or "#00000000",
    -- a no-op rather than nil: dropping the prop may not clear the old handler
    onClick = disabled and function() end or onClick,
    onHover = "onRowHover",
  }, {
    ui.label({ text = check and "✓" or "", fontSize = 12, width = 10, color = active and "on_primary" or color }),
    ui.label({ text = text, fontSize = 13, maxLines = 1, flexGrow = 1, color = active and "on_primary" or color }),
    ui.label({ text = right or "", fontSize = 12, color = active and "on_primary" or (disabled and color or "on_surface_variant") }),
  })
end

local function separator()
  return ui.column({ paddingH = 3, paddingV = 5 }, {
    ui.box({ height = 1, fill = "on_surface/0.12" }),
  })
end

local function menuView()
  local name = app.name
  local rows = {
    row("about", "About " .. name, nil, function()
      show("about")
    end),
    separator(),
    row("new", "New Window", shortcut("wm new-window"), function()
      run({ wm, "new-window", app.appId })
    end),
    separator(),
  }
  if Wm.hyprland then
    table.insert(rows, row("zoom", "Zoom", shortcut('hl.dsp.window.fullscreen({ mode = "maximized" })'), function()
      onHyprland("hl.dsp.window.fullscreen", 'mode = "maximized"')
    end))
    -- window.center only moves floating windows
    table.insert(rows, row("center", "Center", nil, function()
      onHyprland("hl.dsp.window.center")
    end, false, not app.floating))
    table.insert(rows, row("fullscreen", "Enter Full Screen", shortcut("hl.dsp.window.fullscreen()"), function()
      onHyprland("hl.dsp.window.fullscreen", 'mode = "fullscreen"')
    end))
    table.insert(rows, row("float", app.floating and "Tile Window" or "Float Window", shortcut('hl.dsp.window.float({ action = "toggle" })'), function()
      onHyprland("hl.dsp.window.float", 'action = "toggle"')
    end))
    -- workspaces are numbered from 1
    table.insert(rows, row("down", "Previous Workspace", nil, function()
      onHyprland("hl.dsp.window.move", 'workspace = "-1"')
    end, false, app.workspaceId <= 1))
    table.insert(rows, row("up", "Next Workspace", nil, function()
      onHyprland("hl.dsp.window.move", 'workspace = "+1"')
    end))
    table.insert(rows, row("close", "Close Window", shortcut("hl.dsp.window.close()"), function()
      onHyprland("hl.dsp.window.close")
    end))
  else
    local niriRows = {
      row("zoom", "Zoom", shortcut("maximize-window-to-edges"), function()
        onWindow("maximize-window-to-edges")
      end),
      row("center", "Center", shortcut("center-column"), function()
        focusThen("center-column")
      end),
      row("fullscreen", "Enter Full Screen", shortcut("fullscreen-window"), function()
        onWindow("fullscreen-window")
      end),
      row("float", app.floating and "Tile Window" or "Float Window", shortcut("toggle-window-floating"), function()
        onWindow("toggle-window-floating")
      end),
      row("up", "Workspace Above", shortcut("move-column-to-workspace-up"), function()
        focusThen("move-column-to-workspace-up")
      end),
      row("down", "Workspace Below", shortcut("move-column-to-workspace-down"), function()
        focusThen("move-column-to-workspace-down")
      end),
      row("close", "Close Window", shortcut("close-window"), function()
        onWindow("close-window")
      end),
    }
    for _, niriRow in ipairs(niriRows) do
      table.insert(rows, niriRow)
    end
  end
  table.insert(rows, separator())
  table.insert(rows, row("quit", "Quit " .. name, nil, function()
    run({ wm, "quit-app", app.appId })
  end))
  table.insert(rows, row("force", "Force Quit " .. name .. "…", nil, function()
    show("confirm")
  end))
  -- fixed set of rows, so no scroll container (it would add its own spacing)
  return ui.column({ padding = 0, onHover = "onMenuHover" }, rows)
end

local function aboutView()
  local i = info or {}
  local icon = i.icon and i.icon ~= "" and noctalia.appIconPath(i.desktopId or app.appId, 64) or nil
  return ui.column({ padding = 5, gap = 12, onHover = "onMenuHover" }, {
    row("back", "‹  About " .. app.name, nil, function()
      show("menu")
    end),
    ui.column({ gap = 6, align = "center" }, {
      icon and ui.image({ path = icon, width = 64, height = 64 }) or ui.glyph({ name = "app-window", size = 48 }),
      ui.label({ text = i.name or app.name, fontSize = 15, fontWeight = "bold" }),
      ui.label({ text = (i.version and i.version ~= "") and ("Version " .. i.version) or "", fontSize = 11, color = "on_surface_variant" }),
      ui.label({ text = i.comment or "", fontSize = 11, color = "on_surface_variant", maxLines = 2, textAlign = "center" }),
      ui.label({ text = app.appId, fontSize = 10, color = "on_surface_variant" }),
    }),
  })
end

local function confirmView()
  return Alert.view("Do you want to force quit " .. app.name .. "?", "You will lose any unsaved changes.", {
    {
      text = "Force Quit",
      style = "destructive",
      onClick = function()
        run({ wm, "force-quit", app.appId })
      end,
    },
    {
      text = "Cancel",
      style = "cancel",
      onClick = function()
        show("menu")
      end,
    },
  })
end

function render()
  if app == nil then
    panel.render(ui.column({ padding = 14 }, {}))
  elseif app == false then
    panel.render(ui.column({ padding = 14 }, {
      ui.label({ text = "No app is focused.", fontSize = 13, color = "on_surface_variant" }),
    }))
  elseif view == "about" then
    panel.render(aboutView())
  elseif view == "confirm" then
    panel.render(confirmView())
  else
    panel.render(menuView())
  end
end

-- the app's window is the most recently focused one: the open panel itself holds
-- keyboard focus, so niri reports no focused window while it is up
local function lastFocused(list)
  local best
  for _, window in ipairs(list) do
    if window.is_focused then
      return window
    end
    local t = window.focus_timestamp
    local stamp = t and (t.secs * 1e9 + t.nanos) or -1
    if best == nil or stamp > best.stamp then
      best = { window = window, stamp = stamp }
    end
  end
  return best and best.window
end

local function load()
  app = nil
  render()
  if Wm.hyprland then
    -- the app name widget follows the frontmost window (menubar-wm hypr-watch)
    local shared = noctalia.state.get("focused")
    if shared then
      app = {
        id = shared.id,
        appId = shared.appId,
        name = shared.name,
        title = shared.title,
        pid = shared.pid,
        floating = shared.floating,
        workspaceId = shared.workspaceId,
      }
      loadInfo()
    else
      app = false
    end
    render()
    return
  end
  noctalia.runAsync({ "niri", "msg", "--json", "windows" }, function(result)
    local list = noctalia.json.decode(result.stdout or "") or {}
    local window = lastFocused(list)
    if window and window.app_id then
      local shared = noctalia.state.get("focused")
      app = {
        id = window.id,
        appId = window.app_id,
        -- the widget already resolved the display name; app-info refines it below
        name = (shared and shared.appId == window.app_id and shared.name) or window.app_id,
        title = window.title or "",
        pid = window.pid or 0,
        floating = window.is_floating == true,
      }
      loadInfo()
    else
      app = false
    end
    render()
  end)
end

-- `noctalia msg panel-open yunix/menubar:app-menu about` opens About directly
function onOpen(context)
  noctalia.state.set("menuOpen", "app") -- lights the app name's pill
  view, hovered = context == "about" and "about" or "menu", nil
  binds = Binds.read(Wm.hyprland)
  load()
end

function onClose()
  if noctalia.state.get("menuOpen") == "app" then
    noctalia.state.set("menuOpen", nil)
  end
end
