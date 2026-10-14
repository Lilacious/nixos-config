-- macOS 27 alert, as in the kit's "Alerts/Dark/Stacked": a bold title, informative
-- text, and full-width capsule buttons stacked at the bottom (27pt tall, 7pt apart).
-- The menu's panel is the alert's frame; noctalia adds its ~13pt inset around it.

local M = {}

-- kit button colors: the preferred action in the accent color, a destructive one
-- as red text on dark red, Cancel as white text on gray
local styles = {
  preferred = { fill = "primary", color = "on_primary" },
  destructive = { fill = "#ff453a33", color = "#ff453a" },
  cancel = { fill = "on_surface/0.1", color = "on_surface" },
}

-- { text, style = "preferred" | "destructive" | "cancel", onClick }
local function button(spec)
  local style = styles[spec.style] or styles.cancel
  return ui.row({
    height = 27,
    radius = 13.5, -- capsule
    align = "center",
    justify = "center",
    fill = style.fill,
    onClick = spec.onClick,
  }, {
    ui.label({ text = spec.text, fontSize = 13, color = style.color, maxLines = 1 }),
  })
end

-- title, informative text (may be nil) and the buttons, preferred first
function M.view(title, info, buttons)
  local children = {
    ui.label({ text = title, fontSize = 13, fontWeight = "bold", maxLines = 3 }),
  }
  if info and info ~= "" then
    table.insert(children, ui.label({ text = info, fontSize = 13, maxLines = 4 }))
  end
  table.insert(children, ui.spacer({ flexGrow = 1 }))
  local column = {}
  for _, spec in ipairs(buttons) do
    table.insert(column, button(spec))
  end
  table.insert(children, ui.column({ gap = 7, align = "stretch" }, column))
  return ui.column({ paddingH = 3, paddingV = 3, gap = 10, align = "stretch", flexGrow = 1 }, children)
end

return M
