-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- Vim-style window focus / swap (hjkl instead of arrows).
-- Note: SUPER+J was Toggle window split; SUPER+K was Keybindings;
-- SUPER+L was Toggle workspace layout — relocated below.

hl.unbind("SUPER + LEFT")
hl.unbind("SUPER + RIGHT")
hl.unbind("SUPER + UP")
hl.unbind("SUPER + DOWN")
hl.unbind("SUPER + SHIFT + LEFT")
hl.unbind("SUPER + SHIFT + RIGHT")
hl.unbind("SUPER + SHIFT + UP")
hl.unbind("SUPER + SHIFT + DOWN")

hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")

o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))

o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))

o.bind("SUPER + CTRL + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + ALT + SHIFT + K", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- Dictation push-to-talk on SUPER+comma (Wispr-style). Note: SUPER+comma was
-- Dismiss last notification — relocated to SUPER+period.
-- xkbcommon keysyms must be lower-case ("comma", "period").
-- The stop bind ignores mods: releasing SUPER before comma changes the modmask,
-- so a "SUPER + comma" release bind never fires and recording hangs until the
-- 60s cap. The flag keeps plain comma typing from spawning `voxtype` each time.
hl.unbind("SUPER + comma")
o.bind("SUPER + period", "Dismiss last notification", "omarchy-shell notifications dismissOne")
if o.cmd_present("voxtype") then
  local dictating = false
  hl.bind("SUPER + comma", function()
    dictating = true
    hl.exec_cmd("voxtype record start")
  end, { description = "Start dictation (push-to-talk)" })
  hl.bind("comma", function()
    if dictating then
      dictating = false
      hl.exec_cmd("voxtype record stop")
    end
  end, { release = true, ignore_mods = true, non_consuming = true, description = "Stop dictation (push-to-talk)" })
end
