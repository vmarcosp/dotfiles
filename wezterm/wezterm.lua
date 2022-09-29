local wezterm = require 'wezterm'

return {
  font = wezterm.font('SpaceMono Nerd Font Mono', { weight = "Regular" }),
  font_size = 18,
	use_fancy_tab_bar = false,
	inactive_pane_hsb = {
		brightness = 0.7,
	},
  line_height = 1.5,
	hide_tab_bar_if_only_one_tab = true,
  color_scheme = "Catppuccin Mocha",
	window_decorations = "RESIZE",
  window_padding = {
		left = 24,
		right = 24,
		top = 32,
		bottom = 24,
	},
}
