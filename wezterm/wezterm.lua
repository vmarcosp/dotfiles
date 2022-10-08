local wezterm = require 'wezterm'

return {
  font = wezterm.font('FiraCode Nerd Font', { weight = "Bold", italic = false, }),
  font_size = 16,
	use_fancy_tab_bar = false,
  line_height = 2.0,
	hide_tab_bar_if_only_one_tab = true,
  color_scheme = "Catppuccin Mocha",
	window_decorations = "RESIZE",
  window_padding = {
		left = 36,
		right = 36,
		top = 42,
		bottom = 32,
	},
}
