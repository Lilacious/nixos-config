-- Control Center switches icon on the bar; clicking it drops the Control Center down
-- underneath. Drawn like the logo and app name (a full-round pill as tall as noctalia's capsule), lit while the
-- panel is open, as macOS does.

local pillHeight = require("./lib/pill.luau").height()

local function render(open)
  barWidget.render(ui.row({
    height = pillHeight, -- noctalia's capsule: bar thickness x capsule_thickness
    paddingH = 8, -- kit padding x 0.88
    radius = pillHeight / 2, -- fully round
    align = "center",
    -- always set a fill: dropping the prop does not clear the old one
    fill = open and "on_surface/0.1" or "#00000000", -- = noctalia's hover pill (on_surface at 10%)
  }, {
    ui.glyph({ name = "toggle-right", size = 16 }),
  }))
end

noctalia.state.watch("menuOpen", function(menu)
  render(menu == "control")
end)

function onClick()
  noctalia.togglePanel("yunix/menubar:control-center")
end

render(noctalia.state.get("menuOpen") == "control")
