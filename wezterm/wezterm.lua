local wezterm = require 'wezterm'

return {
  font = wezterm.font('SpaceMono Nerd Font Mono', { weight = "Bold" }),
  font_size = 18,
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
	use_fancy_tab_bar = false,
  line_height = 1.7,
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
