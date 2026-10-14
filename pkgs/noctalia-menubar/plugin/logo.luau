-- Logo on the bar; clicking it drops the Apple menu down underneath.
-- Drawn exactly like the bar's other items (noctalia's full-round capsule; text and padding at the kit's x 0.88), so
-- hover and the "menu open" pill look the same across the whole left side.

local pillHeight = require("./lib/pill.luau").height()

local function render(open)
  barWidget.render(ui.row({
    height = pillHeight, -- noctalia's capsule: bar thickness x capsule_thickness
    paddingH = 8.4, -- kit padding x 0.88
    radius = pillHeight / 2, -- fully round
    align = "center",
    -- always set a fill: dropping the prop does not clear the old one
    fill = open and "on_surface/0.1" or "#00000000", -- = noctalia's hover pill (on_surface at 10%)
  }, {
    ui.image({
      path = "/run/current-system/sw/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg",
      width = 12.3, -- kit 14 x 0.88
      height = 12.3,
    }),
  }))
end

noctalia.state.watch("menuOpen", function(menu)
  render(menu == "apple")
end)

function onClick()
  noctalia.togglePanel("yunix/menubar:apple-menu")
end

render(noctalia.state.get("menuOpen") == "apple")
