-- Extra autostart processes.
-- o.launch_on_start("my-service")
if require("hypr.machine") == "pc" then
  o.launch_on_start("qbittorrent")
end

-- MacBook login layout. Rules stay disabled outside the login window so
-- windows opened later land on the current workspace.
if require("hypr.machine") == "macbook" then
  local startup_apps = {
    { desktop = "google-chrome.desktop", class = "^google-chrome$", workspace = "1" },
    { desktop = "com.mitchellh.ghostty.desktop", class = "^com\\.mitchellh\\.ghostty$", workspace = "2" },
    { desktop = "todoist.desktop", class = "^todoist$", workspace = "3" },
    { desktop = "obsidian.desktop", class = "^md\\.obsidian\\.Obsidian$", workspace = "4" },
  }

  local rules = {}
  for _, app in ipairs(startup_apps) do
    local rule = hl.window_rule({
      name = "startup-" .. app.workspace,
      match = { initial_class = app.class },
      workspace = app.workspace .. " silent",
    })
    rule:set_enabled(false)
    table.insert(rules, rule)
  end

  hl.on("hyprland.start", function()
    for _, rule in ipairs(rules) do
      rule:set_enabled(true)
    end

    for _, app in ipairs(startup_apps) do
      hl.exec_cmd(o.launch(app.desktop))
    end

    hl.timer(function()
      for _, rule in ipairs(rules) do
        rule:set_enabled(false)
      end
    end, { timeout = 30000, type = "oneshot" })
  end)
end
