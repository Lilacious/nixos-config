-- Spotlight-style app launcher in the look of the menubar menus: a capsule search
-- field and up to six apps with icon, name and description. Up/Down select,
-- Enter opens, Esc closes. Apps come from bin/menubar-wm, most used first.

local wm = noctalia.pluginDir() .. "/bin/menubar-wm"
local MAX = 6 -- keeps the panel in proportion to the compact bar and dock

local apps = {} -- { id, path, name, comment, keywords, icon, usage }, most used first
local results = {}
local query = ""
local selected = 1
local opens = 0 -- a fresh input key per open, so the field is empty and focused

---------------------------------------------------------------- data

-- no query: the most used apps; otherwise fuzzy matches on name (keywords as fallback)
local function filter()
  results = {}
  local q = noctalia.string.trim(query)
  if q == "" then
    for i = 1, math.min(MAX, #apps) do
      results[i] = apps[i]
    end
  else
    local hits = {}
    for _, app in ipairs(apps) do
      local score = noctalia.fuzzyScore(q, app.name)
      if score == nil and app.keywords ~= "" then
        local keyword = noctalia.fuzzyScore(q, app.keywords)
        score = keyword and keyword / 2 -- a keyword hit ranks below a name hit
      end
      if score then
        table.insert(hits, { app = app, score = score })
      end
    end
    table.sort(hits, function(a, b)
      if a.score ~= b.score then
        return a.score > b.score
      end
      return a.app.usage > b.app.usage
    end)
    for i = 1, math.min(MAX, #hits) do
      results[i] = hits[i].app
    end
  end
  selected = math.max(1, math.min(selected, #results))
end

local function loadApps()
  noctalia.runAsync({ wm, "apps" }, function(result)
    apps = noctalia.json.decode(result.stdout or "") or {}
    filter()
    render()
  end)
end

---------------------------------------------------------------- actions

local function open(app)
  if not app then
    return
  end
  panel.close()
  noctalia.runAsync({ wm, "launch", app.path })
end

function onQuery(text)
  query = text or ""
  selected = 1
  filter()
  render()
end

function onEnter()
  open(results[selected])
end

function onKey(chord, pressed)
  if not pressed or #results == 0 then
    return
  end
  if chord == "Down" then
    selected = selected % #results + 1
  elseif chord == "Up" then
    selected = (selected - 2) % #results + 1
  end
  render()
end

---------------------------------------------------------------- views

local function row(i, app)
  local active = i == selected
  -- resolved by menubar-wm: looking icons up here exceeds the script's time budget
  local icon = app.icon ~= "" and app.icon or nil
  local text = {
    ui.label({ text = app.name, fontSize = 13, maxLines = 1, color = active and "on_primary" or "on_surface" }),
  }
  if app.comment ~= "" then
    table.insert(text, ui.label({
      text = app.comment,
      fontSize = 11,
      maxLines = 1,
      color = active and "on_primary/0.8" or "on_surface_variant",
    }))
  end
  return ui.row({
    key = "hit-" .. i,
    height = 36,
    paddingH = 8,
    gap = 10,
    radius = 9,
    align = "center",
    -- always set a fill: dropping the prop does not clear the old one
    fill = active and "primary" or "#00000000",
    onClick = function()
      open(app)
    end,
    onHover = function(state)
      if state == "true" and selected ~= i then
        selected = i
        render()
      end
    end,
  }, {
    icon and ui.image({ path = icon, width = 26, height = 26 })
      or ui.glyph({ name = "app-window", size = 22, color = active and "on_primary" or "on_surface_variant" }),
    ui.column({ gap = 1, flexGrow = 1 }, text),
    ui.label({ text = active and "↩" or "", fontSize = 12, color = active and "on_primary" or "on_surface_variant" }),
  })
end

local function heading(text)
  return ui.row({ height = 20, paddingH = 8, align = "center" }, {
    ui.label({ text = text, fontSize = 11, fontWeight = "bold", color = "on_surface_variant" }),
  })
end

function render()
  local children = {
    -- the search field: a capsule like Spotlight's, the input itself frameless
    ui.row({
      height = 40,
      paddingH = 14,
      gap = 10,
      radius = 20,
      align = "center",
      fill = "on_surface/0.08",
    }, {
      ui.glyph({ name = "search", size = 16, color = "on_surface_variant" }),
      ui.input({
        key = "query-" .. opens,
        value = "",
        placeholder = "Spotlight Search",
        fontSize = 16,
        frameVisible = false,
        focus = true,
        flexGrow = 1,
        onChange = "onQuery",
        onSubmit = "onEnter",
      }),
    }),
    ui.box({ height = 6, fill = "#00000000" }), -- spacing only; a box draws a fill by default
    heading(noctalia.string.trim(query) == "" and "Suggestions" or "Applications"),
  }
  -- rows sit almost flush, like the menus
  local rows = {}
  for i, app in ipairs(results) do
    table.insert(rows, row(i, app))
  end
  if #results == 0 then
    table.insert(rows, heading(#apps == 0 and "Loading…" or "No results"))
  end
  table.insert(children, ui.column({ gap = 2 }, rows))
  panel.render(ui.column({ gap = 2 }, children))
end

function onOpen()
  opens = opens + 1
  query, selected = "", 1
  filter()
  render()
  loadApps() -- refresh: new apps and usage
end
