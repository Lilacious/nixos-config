-- Keyboard shortcuts as bound in the niri or Hyprland config, so menus show what is
-- actually set.
local M = {}

local function trim(text)
  return noctalia.string.trim(text)
end

-- without spaces, so 'hl.dsp.window.fullscreen({ mode = "maximized" })' matches however
-- it is spaced
local function squash(text)
  return (string.gsub(text, "%s", ""))
end

local hyprlandMods = {
  SUPER = "Mod", WIN = "Mod", LOGO = "Mod", MOD4 = "Mod", META = "Mod",
  CTRL = "Ctrl", CONTROL = "Ctrl",
  ALT = "Alt", MOD1 = "Alt",
  SHIFT = "Shift",
}

-- hyprland.lua as home-manager writes it, one bind per line:
--   hl.bind("SUPER + SHIFT + left", (hl.dsp.window.move({ direction = "left" })))
--   hl.bind("XF86AudioMute", (hl.dsp.exec_cmd("noctalia msg volume-mute")), {
-- the action is the dispatcher expression inside the parentheses
local function readHyprland()
  local binds = {}
  local text = noctalia.readFile("~/.config/hypr/hyprland.lua")
  if not text then
    return binds
  end
  for line in string.gmatch(text, "[^\n]+") do
    local keys, rest = string.match(line, '^%s*hl%.bind%("([^"]*)",%s*(.*)$')
    -- mouse buttons are no shortcuts
    if keys and not string.find(keys, "mouse", 1, true) then
      local action = string.match(rest, "^%((.*)%),%s*{%s*$") or string.match(rest, "^%((.*)%)%)%s*$")
      if action then
        local mods, key = {}, nil
        for part in string.gmatch(keys, "[^+]+") do
          part = trim(part)
          local name = hyprlandMods[string.upper(part)]
          if name then
            mods[name] = true
          else
            key = part
          end
        end
        if key then
          local chord = {}
          for _, name in ipairs({ "Mod", "Ctrl", "Alt", "Shift" }) do
            if mods[name] then
              table.insert(chord, name)
            end
          end
          -- left -> Left, like niri's key names
          if #key > 1 then
            key = string.gsub(key, "^%l", string.upper)
          end
          table.insert(chord, key)
          -- compact once here: comparing on every lookup exceeds the script's time budget
          table.insert(binds, { chord = table.concat(chord, "+"), action = action, compact = squash(action) })
        end
      end
    end
  end
  return binds
end

-- top-level binds in config.kdl: "\tMod+Ctrl+Q {" followed by one action line
function M.read(hyprland: boolean?)
  if hyprland then
    return readHyprland()
  end
  local binds = {}
  local text = noctalia.readFile("~/.config/niri/config.kdl")
  if not text then
    return binds
  end
  local chord
  for line in string.gmatch(text, "[^\n]+") do
    local key = string.match(line, "^\t([%w%+_]+)[^{]*{%s*$")
    if key then
      chord = key
    elseif chord then
      local action = noctalia.string.trim(line)
      if action ~= "}" and string.sub(action, 1, 2) ~= "//" then
        table.insert(binds, { chord = chord, action = action })
        chord = nil
      end
    end
  end
  return binds
end

-- shortest chord bound to the first of `actions` that has one; an entry starting with
-- "wm " matches a menubar-wm subcommand ("wm new-window" -> spawn-sh "…/menubar-wm new-window",
-- or hl.dsp.exec_cmd("…/menubar-wm new-window") on Hyprland)
function M.find(binds, actions)
  for _, wanted in ipairs(actions) do
    local script = string.match(wanted, "^wm (.+)$")
    local compact = squash(wanted)
    local best
    for _, bind in ipairs(binds) do
      -- niri binds compare as written, Hyprland ones without spaces
      local hit = bind.action == wanted or bind.compact == compact
      if script then
        local _, last = string.find(bind.action, "menubar-wm " .. script, 1, true)
        -- the subcommand ends there: a quote, a space or the end, not "new-window-x"
        hit = last ~= nil and not string.find(string.sub(bind.action, last + 1, last + 1), "[%w%-]")
      end
      if hit and (best == nil or #bind.chord < #best) then
        best = bind.chord
      end
    end
    if best then
      return M.format(best)
    end
  end
  return nil
end

-- Mod+Alt+L -> Super+Alt+L: plain key names, as niri's own hotkey overlay writes them
local modifierNames = { Mod = "Super", Super = "Super", Ctrl = "Ctrl", Alt = "Alt", Shift = "Shift" }
local modifierOrder = { "Mod", "Super", "Ctrl", "Alt", "Shift" }
local keyNames = {
  Page_Up = "Page Up", Page_Down = "Page Down", BackSpace = "Backspace", Return = "Enter",
  Escape = "Esc", Minus = "-", Equal = "=", BracketLeft = "[", BracketRight = "]",
  Comma = ",", Period = ".", Slash = "/", less = "<",
}

function M.format(chord)
  local parts = {}
  for part in string.gmatch(chord, "[^+]+") do
    table.insert(parts, part)
  end
  local key = table.remove(parts)
  local present = {}
  for _, part in ipairs(parts) do
    present[part] = true
  end
  local out = {}
  for _, name in ipairs(modifierOrder) do
    if present[name] and not (name == "Super" and present.Mod) then
      table.insert(out, modifierNames[name])
    end
  end
  table.insert(out, keyNames[key] or (#key == 1 and string.upper(key) or key))
  return table.concat(out, "+")
end

return M
