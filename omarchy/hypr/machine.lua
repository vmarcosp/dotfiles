-- install.sh writes ~/.config/omarchy/machine as "pc" or "macbook".
-- Missing or unknown values stay on the desktop profile.
local path = (os.getenv("HOME") or "") .. "/.config/omarchy/machine"
local f = io.open(path, "r")
local machine = "pc"
if f then
  machine = (f:read("*l") or "pc"):gsub("%s+", "")
  f:close()
end
if machine ~= "pc" and machine ~= "macbook" then
  machine = "pc"
end
return machine
