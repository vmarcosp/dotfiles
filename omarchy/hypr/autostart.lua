-- Extra autostart processes.
-- o.launch_on_start("my-service")
if require("hypr.machine") == "pc" then
  o.launch_on_start("qbittorrent")
end
