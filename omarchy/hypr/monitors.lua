-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- 1080p 27" desktop: integer scale 1. GDK_SCALE=2 is for HiDPI laptops.
local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- AOC 27G2G8 lists 60 Hz first, so "preferred" stuck at 60. Use the panel's 240 Hz mode.
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@239.96", position = "0x0", scale = omarchy_monitor_scale })

-- Fallback for any other display.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
