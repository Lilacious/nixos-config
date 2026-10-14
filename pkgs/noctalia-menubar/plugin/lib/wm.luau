-- The compositor noctalia runs on. XDG_CURRENT_DESKTOP is imported into the systemd user
-- environment by each session ("niri" or "Hyprland"), unlike HYPRLAND_INSTANCE_SIGNATURE,
-- which stays behind after logging out of Hyprland.
local M = {}

local desktop = noctalia.getenv("XDG_CURRENT_DESKTOP") or ""

M.hyprland = string.find(desktop, "Hyprland", 1, true) ~= nil
M.niri = not M.hyprland

return M
