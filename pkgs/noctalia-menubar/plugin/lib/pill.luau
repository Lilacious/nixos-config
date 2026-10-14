-- The bar item pill, sized like noctalia's own capsule (bar thickness x capsule_thickness),
-- so the plugin's "menu open" pills match noctalia's hover pill on any bar height.
local M = {}

-- falls back to the values these widgets were designed with (a 23pt bar, the kit's 24/34 ratio)
function M.height(): number
  local thickness = tonumber(noctalia.getSetting("bar.default.thickness")) or 23
  local ratio = tonumber(noctalia.getSetting("bar.default.capsule_thickness")) or 0.706
  return math.floor(thickness * ratio + 0.5)
end

return M
