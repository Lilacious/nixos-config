-- Apple-menu style dropdown. Plain rows with a blue hover, thin separators;
-- the "…" items ask first, like on macOS. About opens as a view inside the
-- same panel. Shortcuts are read from the niri or Hyprland config, so they show
-- whatever is actually bound.

local view = "menu" -- menu | about | confirm
local hovered = nil -- key of the row under the pointer
local confirming = nil -- action waiting for confirmation
local Binds = require("./lib/binds.luau")
local Alert = require("./lib/alert.luau")
local Wm = require("./lib/wm.luau")
local binds = {} -- compositor binds, read on open
local about = nil -- { host, model, cpu, gpu, memory, os, kernel, uptime }

local confirmations = {
  reboot = {
    question = "Are you sure you want to restart your computer now?",
    info = "Apps that are open will be closed.",
    button = "Restart",
  },
  shutdown = {
    question = "Are you sure you want to shut down your computer now?",
    info = "Apps that are open will be closed.",
    button = "Shut Down",
  },
  logout = { question = "Are you sure you want to quit all apps and log out now?", button = "Log Out" },
}

-- niri actions that do the same as a menu item, first match wins
local niriActions = {
  settings = { 'spawn-sh "noctalia msg settings-open"', 'spawn-sh "noctalia msg settings-toggle"' },
  sleep = { 'spawn-sh "noctalia msg session lock-and-suspend"', 'spawn-sh "noctalia msg session suspend"' },
  reboot = { 'spawn-sh "noctalia msg session reboot"' },
  shutdown = { 'spawn-sh "noctalia msg session shutdown"' },
  lock = { 'spawn-sh "noctalia msg session lock"' },
  logout = { "quit", 'spawn-sh "noctalia msg session logout"' },
}

-- the same for hyprland.lua binds: the hl.dsp dispatcher
local hyprlandActions = {
  settings = { 'hl.dsp.exec_cmd("noctalia msg settings-open")', 'hl.dsp.exec_cmd("noctalia msg settings-toggle")' },
  sleep = { 'hl.dsp.exec_cmd("noctalia msg session lock-and-suspend")', 'hl.dsp.exec_cmd("noctalia msg session suspend")' },
  reboot = { 'hl.dsp.exec_cmd("noctalia msg session reboot")' },
  shutdown = { 'hl.dsp.exec_cmd("noctalia msg session shutdown")' },
  lock = { 'hl.dsp.exec_cmd("noctalia msg session lock")' },
  logout = { "hl.dsp.exit()", 'hl.dsp.exec_cmd("noctalia msg session logout")' },
}

local shortcutActions = Wm.hyprland and hyprlandActions or niriActions

---------------------------------------------------------------- data

-- Mod+Ctrl+Q -> Super+Ctrl+Q, whatever the compositor has bound for the item
local function shortcut(item)
  return Binds.find(binds, shortcutActions[item] or {})
end

local function loadAbout()
  noctalia.runAsync(
    [[
echo "host=$(uname -n)"
echo "model=$(cat /sys/class/dmi/id/product_version 2>/dev/null)"
echo "cpu=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | sed 's/(R)//g; s/(TM)//g; s/ CPU//; s/^ *//')"
echo "gpu=$(lspci 2>/dev/null | grep -m1 -E 'VGA|3D' | cut -d: -f3 | sed 's/ Corporation//; s/^ *//')"
echo "memory=$(awk '/MemTotal/ {printf "%.0f GB", $2 / 1048576}' /proc/meminfo)"
echo "os=$(nixos-version)"
echo "kernel=$(uname -r)"
echo "uptime=$(awk '{d=int($1/86400); h=int($1%86400/3600); m=int($1%3600/60); if (d) printf "%d d ", d; printf "%d h %d min", h, m}' /proc/uptime)"
]],
    function(result)
      about = {}
      for key, value in string.gmatch(result.stdout, "(%w+)=([^\n]*)") do
        about[key] = value
      end
      if view == "about" then
        render()
      end
    end
  )
end

---------------------------------------------------------------- actions

local function run(command)
  panel.close()
  noctalia.runAsync(command)
end

local function show(next)
  view, hovered = next, nil
  render()
end

local function ask(action)
  confirming = action
  show("confirm")
end

---------------------------------------------------------------- hover

-- one named handler for every row: it gets the row's key, so it survives re-renders
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

-- pointer left the whole menu: nothing stays highlighted
function onMenuHover(state)
  if state == "false" and hovered ~= nil then
    hovered = nil
    render()
  end
end

---------------------------------------------------------------- views

local function row(key, text, right, onClick)
  local active = hovered == key
  local children = {}
  table.insert(children, ui.label({
    text = text,
    fontSize = 13,
    maxLines = 1,
    color = active and "on_primary" or "on_surface",
    flexGrow = 1,
  }))
  table.insert(children, ui.label({
    text = right or "",
    fontSize = 12,
    color = active and "on_primary" or "on_surface_variant",
  }))
  return ui.row({
    key = key,
    height = 24,
    paddingH = 3, -- + noctalia 13 = macOS 16pt inset
    gap = 8,
    radius = 7, -- macOS 27 hover pill
    align = "center",
    -- always set a fill: dropping the prop does not clear the old one
    fill = active and "primary" or "#00000000",
    onClick = onClick,
    onHover = "onRowHover",
  }, children)
end

local function separator()
  return ui.column({ paddingH = 3, paddingV = 5 }, {
    ui.box({ height = 1, fill = "on_surface/0.12" }),
  })
end

local function backRow(title)
  return row("back", "‹  " .. title, nil, function()
    show("menu")
  end)
end

local function menuView()
  -- noctalia already pads panels ~13pt; adding nothing keeps the macOS 16pt text inset
  return ui.column({ padding = 0, onHover = "onMenuHover" }, {
    row("about", "About This Computer", nil, function()
      show("about")
    end),
    separator(),
    row("settings", "System Settings…", shortcut("settings"), function()
      run("noctalia msg settings-open")
    end),
    separator(),
    row("sleep", "Sleep", shortcut("sleep"), function()
      run("noctalia msg session lock-and-suspend")
    end),
    row("reboot", "Restart…", shortcut("reboot"), function()
      ask("reboot")
    end),
    row("shutdown", "Shut Down…", shortcut("shutdown"), function()
      ask("shutdown")
    end),
    separator(),
    row("lock", "Lock Screen", shortcut("lock"), function()
      run("noctalia msg session lock")
    end),
    row("logout", "Log Out " .. (noctalia.getenv("USER") or "") .. "…", shortcut("logout"), function()
      ask("logout")
    end),
  })
end

local function aboutView()
  local a = about or {}
  local function line(label, value)
    return ui.row({ gap = 8 }, {
      ui.label({ text = label, fontSize = 11, fontWeight = "bold", width = 58, textAlign = "end" }),
      ui.label({ text = value or "…", fontSize = 11, color = "on_surface_variant", maxLines = 1, flexGrow = 1 }),
    })
  end
  -- "26.11.20261011.7fd4004 (Zokor)" -> "26.11 Zokor"
  local version, codename = string.match(a.os or "", "^(%d+%.%d+)[^%(]*%((%w+)%)")
  return ui.column({ padding = 5, gap = 10, onHover = "onMenuHover" }, {
    backRow("About This Computer"),
    ui.row({ gap = 12, paddingH = 10, align = "center" }, {
      ui.image({
        path = "/run/current-system/sw/share/icons/hicolor/scalable/apps/nix-snowflake.svg",
        width = 40,
        height = 40,
      }),
      ui.column({ gap = 2, flexGrow = 1 }, {
        ui.label({ text = version and ("NixOS " .. codename) or "NixOS", fontSize = 15, fontWeight = "bold" }),
        ui.label({ text = version and ("Version " .. version) or "", fontSize = 11, color = "on_surface_variant" }),
      }),
    }),
    ui.column({ gap = 4, paddingH = 4 }, {
      line("Computer", (a.model or "…") .. (a.host and (" · " .. a.host) or "")),
      line("Chip", a.cpu),
      line("Graphics", a.gpu),
      line("Memory", a.memory),
      line("Kernel", a.kernel),
      line("Uptime", a.uptime),
    }),
  })
end

local function confirmView()
  local c = confirmations[confirming]
  return Alert.view(c.question, c.info, {
    {
      text = c.button,
      style = "preferred",
      onClick = function()
        run("noctalia msg session " .. confirming)
      end,
    },
    {
      text = "Cancel",
      style = "cancel",
      onClick = function()
        confirming = nil
        show("menu")
      end,
    },
  })
end

function render()
  if view == "about" then
    panel.render(aboutView())
  elseif view == "confirm" and confirming then
    panel.render(confirmView())
  else
    panel.render(menuView())
  end
end

-- `noctalia msg panel-open yunix/menubar:apple-menu about` opens About directly
function onOpen(context)
  noctalia.state.set("menuOpen", "apple") -- lights the logo's pill
  view, hovered, confirming = "menu", nil, nil
  binds = Binds.read(Wm.hyprland)
  loadAbout()
  if context == "about" then
    view = "about"
  end
  render()
end

function onClose()
  if noctalia.state.get("menuOpen") == "apple" then
    noctalia.state.set("menuOpen", nil)
  end
end
