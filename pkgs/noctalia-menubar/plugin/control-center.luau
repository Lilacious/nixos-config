-- macOS-style Control Center, dropped down from the toggle icon in the bar: a grid of
-- tiles on the panel's glass, like Sequoia/Tahoe. A connectivity tile (Wi-Fi,
-- Bluetooth, Airplane Mode), Focus, two small tiles (Low Power Mode, Screenshot),
-- Display and Sound sliders, Now Playing. State comes from bin/menubar-wm cc-state
-- and is refreshed while the panel is open.

local wm = noctalia.pluginDir() .. "/bin/menubar-wm"

-- geometry: 4 columns of 67.5pt with 10pt gaps = 300pt, the panel adds its 13pt inset
local GAP = 10
local CELL = 67.5
local WIDE = CELL * 2 + GAP -- 145
local RADIUS = 12 -- concentric inside the panel's corners
local TILE_FILL = "on_surface/0.08"

local state = nil -- last cc-state
local isOpen = false
local generation = 0 -- stops the refresh loop of an earlier open
local sliding: { [string]: number } = {} -- slider -> time of the last drag, so a refresh does not yank it back

---------------------------------------------------------------- data

local function refresh()
  noctalia.runAsync({ wm, "cc-state" }, function(result)
    local next = noctalia.json.decode(result.stdout or "")
    if not next then
      return
    end
    -- keep a value the user is dragging right now
    local now = noctalia.nowMs()
    if state and sliding.brightness and now - sliding.brightness < 1500 then
      next.brightness = state.brightness
    end
    if state and sliding.volume and now - sliding.volume < 1500 then
      next.volume.value = state.volume.value
    end
    state = next
    if isOpen then
      render()
    end
  end)
end

-- refresh every 2s while open (volume keys, a new song, Wi-Fi joining)
local function poll(gen)
  noctalia.runAsync({ "sleep", "2" }, function()
    if isOpen and gen == generation then
      refresh()
      poll(gen)
    end
  end)
end

-- run a command, then show its effect
local function act(argv)
  noctalia.runAsync(argv, function()
    refresh()
  end)
end

local function msg(...)
  act({ "noctalia", "msg", ... })
end

---------------------------------------------------------------- pieces

local function tile(props, children)
  props.radius = RADIUS
  props.fill = TILE_FILL
  return ui.column(props, children)
end

-- round icon button, blue while on
local function circle(glyph, on, onClick)
  return ui.row({
    width = 28,
    height = 28,
    radius = 14,
    align = "center",
    justify = "center",
    fill = on and "primary" or "on_surface/0.14",
    onClick = onClick,
  }, {
    ui.glyph({ name = glyph, size = 15, color = on and "on_primary" or "on_surface" }),
  })
end

local function titled(title, subtitle)
  return ui.column({ gap = 1, flexGrow = 1 }, {
    ui.label({ text = title, fontSize = 13, fontWeight = "bold", maxLines = 1 }),
    ui.label({ text = subtitle, fontSize = 11, color = "on_surface_variant", maxLines = 1 }),
  })
end

-- icon, title and status in one line of a tile; the whole line toggles
local function toggleRow(glyph, title, subtitle, on, onClick)
  return ui.row({ gap = 9, align = "center", flexGrow = 1, onClick = onClick }, {
    circle(glyph, on, onClick),
    titled(title, subtitle),
  })
end

---------------------------------------------------------------- tiles

local function connectivity()
  local wifi, bt = state.wifi, state.bluetooth
  local airplane = not wifi.on and not bt.on
  return tile({ width = WIDE, height = WIDE, paddingH = 10, paddingV = 6, gap = 0 }, {
    toggleRow("wifi", "Wi-Fi", wifi.on and (wifi.ssid ~= "" and wifi.ssid or "On") or "Off", wifi.on, function()
      msg("wifi-toggle")
    end),
    toggleRow("bluetooth", "Bluetooth", bt.on and (bt.device ~= "" and bt.device or "On") or "Off", bt.on, function()
      msg("bluetooth-toggle")
    end),
    toggleRow("plane", "Airplane", airplane and "On" or "Off", airplane, function()
      act({ wm, "cc", "airplane" })
    end),
  })
end

local function focus()
  return tile({ width = WIDE, height = CELL, paddingH = 10, justify = "center" }, {
    toggleRow("moon", "Focus", state.dnd and "Do Not Disturb" or "Off", state.dnd, function()
      msg("notification-dnd-toggle")
    end),
  })
end

-- small square tile: an icon, lit while on
local function small(glyph, label, on, onClick)
  return ui.column({
    width = CELL,
    height = CELL,
    radius = RADIUS,
    fill = on and "primary" or TILE_FILL,
    align = "center",
    justify = "center",
    gap = 4,
    onClick = onClick,
    tooltip = label,
  }, {
    ui.glyph({ name = glyph, size = 20, color = on and "on_primary" or "on_surface" }),
    ui.label({ text = label, fontSize = 10, color = on and "on_primary" or "on_surface_variant", maxLines = 1 }),
  })
end

-- macOS Control Center slider: a thick grey capsule with a white capsule growing inside
-- it and the icon in its rounded start. Drawn by hand (the native slider has a fixed
-- look); the real slider sits on top, invisible, so clicking and dragging still work.
-- The negative gap stacks the two rows.
local SLIDER_H = 22
local SLIDER_W = WIDE * 2 + GAP - 24 -- tile width minus its 12pt padding on each side

local function slider(key, title, glyph, value, onChange)
  local fillW = SLIDER_H + math.max(0, math.min(1, value)) * (SLIDER_W - SLIDER_H)
  return tile({ width = WIDE * 2 + GAP, paddingH = 12, paddingV = 9, gap = 6 }, {
    ui.label({ text = title, fontSize = 13, fontWeight = "bold" }),
    ui.column({ gap = -SLIDER_H, height = SLIDER_H }, {
      ui.row({ width = SLIDER_W, height = SLIDER_H, radius = SLIDER_H / 2, fill = "on_surface/0.14" }, {
        ui.row({
          width = fillW,
          height = SLIDER_H,
          radius = SLIDER_H / 2,
          paddingH = 5,
          align = "center",
          fill = "#ffffffeb",
        }, {
          ui.glyph({ name = glyph, size = 12, color = "#00000099" }),
        }),
      }),
      ui.slider({
        key = key,
        min = 0,
        max = 1,
        step = 0.01,
        value = value,
        width = SLIDER_W,
        height = SLIDER_H,
        opacity = 0,
        onChange = function(v)
          sliding[key] = noctalia.nowMs()
          onChange(v)
          render() -- move the drawn fill along
        end,
      }),
    }),
  })
end

-- one brightness-set at a time: while one runs, only the latest value waits, so a fast
-- drag does not queue up a command per step
local brightnessBusy, brightnessNext = false, nil

local function setBrightness(percent)
  if brightnessBusy then
    brightnessNext = percent
    return
  end
  brightnessBusy = true
  -- a percentage with a sign: a bare "1" means 1%, not 100%
  noctalia.runAsync({ "noctalia", "msg", "brightness-set", percent .. "%" }, function()
    brightnessBusy = false
    if brightnessNext then
      local next = brightnessNext
      brightnessNext = nil
      setBrightness(next)
    end
  end)
end

local function display()
  return slider("brightness", "Display", "sun", state.brightness or 1, function(v)
    state.brightness = v
    setBrightness(math.max(2, math.floor(v * 100 + 0.5))) -- never all the way to black
  end)
end

local function sound()
  local vol = state.volume
  return slider("volume", "Sound", (vol.muted or vol.value == 0) and "volume-off" or "volume", math.min(1, vol.value), function(v)
    vol.value = v
    noctalia.runAsync({ "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", string.format("%.2f", v) })
  end)
end

local function control(glyph, action)
  return ui.row({ width = 26, height = 26, align = "center", justify = "center", onClick = function()
    msg("media", action)
  end }, {
    ui.glyph({ name = glyph, size = 18, color = "on_surface" }),
  })
end

local function nowPlaying()
  local m = state.media
  local art = m and m.art ~= "" and ui.image({ path = m.art, width = 40, height = 40, radius = 8 })
    or ui.row({ width = 40, height = 40, radius = 8, align = "center", justify = "center", fill = "on_surface/0.12" }, {
      ui.glyph({ name = "music", size = 20, color = "on_surface_variant" }),
    })
  local children = { art }
  if m then
    table.insert(children, titled(m.title ~= "" and m.title or "Unknown", m.artist))
    table.insert(children, control("player-track-prev", "previous"))
    table.insert(children, control(m.playing and "player-pause" or "player-play", "toggle"))
    table.insert(children, control("player-track-next", "next"))
  else
    table.insert(children, titled("Not Playing", ""))
  end
  return tile({ width = WIDE * 2 + GAP, paddingH = 10, paddingV = 10 }, {
    ui.row({ gap = 10, align = "center" }, children),
  })
end

---------------------------------------------------------------- panel

function render()
  if not state then
    panel.render(ui.column({}, {}))
    return
  end
  local tiles = {
    ui.row({ gap = GAP }, {
      connectivity(),
      ui.column({ gap = GAP }, {
        focus(),
        ui.row({ gap = GAP }, {
          small("leaf", "Low Power", state.lowPower, function()
            act({ wm, "cc", "low-power" })
          end),
          small("screenshot", "Screenshot", false, function()
            panel.close()
            noctalia.runAsync({ wm, "screenshot" })
          end),
        }),
      }),
    }),
  }
  -- no Display tile without a built-in backlight (external screens), like macOS
  if state.brightness ~= nil then
    table.insert(tiles, display())
  end
  table.insert(tiles, sound())
  table.insert(tiles, nowPlaying())
  panel.render(ui.column({ gap = GAP }, tiles))
end

function onOpen()
  isOpen = true
  generation = generation + 1
  noctalia.state.set("menuOpen", "control")
  render()
  refresh()
  poll(generation)
end

function onClose()
  isOpen = false
  if noctalia.state.get("menuOpen") == "control" then
    noctalia.state.set("menuOpen", nil)
  end
end
