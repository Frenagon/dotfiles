-- Rounded window corners, matching Omarchy's Solitude theme
-- (decoration.rounding / rounding_power). Omarchy's default is square (0).
--
-- The border colours below just reproduce what Omarchy's hyprland.lua.tpl
-- would generate from this theme's colors.toml (active = accent, inactive =
-- the Omarchy default grey): shipping our own hyprland.lua makes theme-set
-- skip the template for this one file, so we have to set them here too.
local active_border_color = "#C24A42"
local inactive_border_color = "rgba(595959aa)"

hl.config({
  general = {
    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },
  },
  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
    },
  },
  decoration = {
    rounding = 6,
    rounding_power = 3,
  },
})
