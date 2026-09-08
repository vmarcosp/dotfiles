-- Keep only your personal input overrides here. Uncommented settings below
-- replace Omarchy's defaults.

-- Keyboard layout and options.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
-- Physical keyboard is Brazilian ABNT2; US layout made : produce ? and ? produce nothing.
hl.config({
  input = {
    kb_layout = "br",
    kb_model = "abnt2",
    kb_options = "compose:caps,shift:both_capslock_cancel,altwin:swap_ralt_rwin",
  },
})

-- Other input overrides (repeat, mouse, touchpad) stay commented so Omarchy
-- defaults remain. Example:
-- hl.config({
--   input = {
--     repeat_rate = 40,
--     repeat_delay = 250,
--     numlock_by_default = true,
--     sensitivity = 0.35,
--     accel_profile = "flat",
--     touchpad = {
--       natural_scroll = true,
--       clickfinger_behavior = true,
--       scroll_factor = 0.4,
--       disable_while_typing = false,
--       drag_3fg = 1,
--     },
--   },
-- })

-- App-specific touchpad scroll speeds.
-- o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
-- o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })

-- Enable touchpad gestures for changing workspaces.
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Enable touchpad gestures for moving focus (helpful on scrolling layout).
-- hl.gesture({ fingers = 3, direction = "left", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })
-- hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })
