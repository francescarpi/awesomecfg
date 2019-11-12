--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
local gears         = require("gears")
local awful         = require("awful")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

awful.util.spawn("setxkbmap -layout es")

home = os.getenv("HOME")

require("awful.autofocus")
require("awful.hotkeys_popup.keys.vim")

--------------------------------------------------------------------------------
-- Error Handling
--------------------------------------------------------------------------------
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end

--------------------------------------------------------------------------------
-- Visual theme
--------------------------------------------------------------------------------
beautiful.init(awful.util.get_configuration_dir() .. "theme/theme.lua")

--------------------------------------------------------------------------------
-- Loading widgets here for get beautiful cfg
--------------------------------------------------------------------------------
require("widgets.volume.volume")
require("widgets.battery.battery")
require("widgets.screen.screen")
require("widgets.clock.clock")
require("widgets.loadavg.loadavg")
require("widgets.spotify.spotify")
require("widgets.touchpad.touchpad")

--------------------------------------------------------------------------------
-- Terminal, Editor, ModKey...
--------------------------------------------------------------------------------
terminal    = "sakura"
editor      = os.getenv("EDITOR") or "vim"
editor_cmd  = terminal .. " -e " .. editor
modkey      = "Mod4"

--------------------------------------------------------------------------------
-- Layouts
--------------------------------------------------------------------------------
awful.layout.layouts = {
    awful.layout.suit.max,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
}

--------------------------------------------------------------------------------
-- Helper functions
--------------------------------------------------------------------------------
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

--------------------------------------------------------------------------------
-- Main menu
--------------------------------------------------------------------------------
local mymainmenu_theme = {
    height = 30,
    width = 200,
    font = 'Verdana Bold 10'
}

myawesomemenu = {
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end}
}

systemmenu = {
    { "shutdown", function() awful.spawn("shutdown -h now") end },
    { "reboot", function() awful.spawn("reboot") end }
}

mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu },
        { "system", systemmenu },
        { "open terminal", terminal }
    },
    theme = mymainmenu_theme
})

--------------------------------------------------------------------------------
-- Launcher menu
--------------------------------------------------------------------------------
mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu,
})

menubar.utils.terminal = terminal

--------------------------------------------------------------------------------
-- Tags mouse events
--------------------------------------------------------------------------------
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end),
    -- Middle button
    awful.button({ }, 2,
        function(t)
            awful.prompt.run {
                prompt = "Name for tag " .. t.index .. ": ",
                textbox = mouse.screen.mypromptbox.widget,
                exe_callback = function(input)
                    if input == "" then
                        t.name = t.index
                    else
                        t.name = t.index .. ": " .. input:upper()
                    end
                end
            }
        end
    )
)

--------------------------------------------------------------------------------
-- Tasks mouse events
--------------------------------------------------------------------------------
local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 3, client_menu_toggle_fn()),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(-1)
    end)
)

--------------------------------------------------------------------------------
-- Wallpaper
--------------------------------------------------------------------------------
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end
screen.connect_signal("property::geometry", set_wallpaper)


--------------------------------------------------------------------------------
-- Number of tags
--------------------------------------------------------------------------------
local ntags = 5
local tags = {}
for i=1, ntags do tags[i] = i end

--------------------------------------------------------------------------------
-- Events for each screen
--------------------------------------------------------------------------------
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)    
    awful.tag(tags, s, awful.layout.layouts[1])
    s.mypromptbox   = awful.widget.prompt()
    s.mylayoutbox   = awful.widget.layoutbox(s)
    s.mytaglist     = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
    s.mytasklist    = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)
    s.mywibox       = awful.wibar({ position = "top", screen = s, opacity = .9 })
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            {
                widget = wibox.container.margin,
                right = 10,
                s.mylayoutbox,
            },
            s.mypromptbox,
        },
        s.mytasklist,
        {
            layout = wibox.layout.fixed.horizontal,
            touchpad_widget,
            loadavg_widget,
            clock_widget,
            screen_widget,
            battery_widget,
            volume_widget,
            spotify_widget,
            {
                widget = wibox.container.margin,
                top = 1,
                bottom = 1,
                wibox.widget.systray()
            },
        },
    }
end)

--------------------------------------------------------------------------------
-- Mouse bindings
--------------------------------------------------------------------------------
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

--------------------------------------------------------------------------------
-- Global keys
--------------------------------------------------------------------------------
globalkeys = gears.table.join(
    globalkeys,
    awful.key({modkey,}, "s", hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    awful.key({modkey,}, "Left", awful.tag.viewprev,
              {description = "view previous", group = "tag"}),

    awful.key({modkey,}, "Right", awful.tag.viewnext,
              {description = "view next", group = "tag"}),

    awful.key({modkey,}, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({modkey,}, "j", function () awful.client.focus.byidx(-1) end,
              {description = "focus next by index", group = "client"}),

    awful.key({modkey,}, "º", function () awful.client.focus.byidx(1) end,
              {description = "focus next by index", group = "client"}),

    awful.key({modkey,}, "k", function () awful.client.focus.byidx(1) end,
              {description = "focus previous by index", group = "client"}),

    awful.key({modkey,}, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    awful.key({modkey, "Shift"}, "j", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with next client by index", group = "client"}),

    awful.key({modkey, "Shift"}, "k", function () awful.client.swap.byidx( 1)    end,
              {description = "swap with previous client by index", group = "client"}),

    awful.key({modkey, "Control"}, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),

    awful.key({modkey, "Control"}, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),

    awful.key({modkey,}, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    awful.key({modkey,}, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    awful.key({modkey,}, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),

    awful.key({modkey, "Control"}, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    awful.key({modkey,}, "l", function () awful.tag.incmwfact(0.05) end,
              {description = "increase master width factor", group = "layout"}),

    awful.key({modkey,}, "h", function () awful.tag.incmwfact(-0.05) end,
              {description = "decrease master width factor", group = "layout"}),

    awful.key({modkey, "Shift"}, "h", function () awful.tag.incnmaster(1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),

    awful.key({modkey, "Shift"}, "l", function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),

    awful.key({modkey, "Control"}, "h", function () awful.tag.incncol(1, nil, true) end,
              {description = "increase the number of columns", group = "layout"}),

    awful.key({modkey, "Control"}, "l", function () awful.tag.incncol(-1, nil, true) end,
              {description = "decrease the number of columns", group = "layout"}),

    awful.key({modkey,}, "space", function () awful.layout.inc(1) end,
              {description = "select next", group = "layout"}),

    awful.key({modkey, "Shift"}, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    awful.key({modkey}, "r", function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({modkey}, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),

    awful.key({modkey}, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    awful.key({modkey}, "d", function() awful.spawn("rofi -show") end),

    -- Screenshot. Rectangle to Download
    awful.key({}, "Print", function() awful.spawn("flameshot gui") end)
)

--------------------------------------------------------------------------------
-- Client keys
--------------------------------------------------------------------------------
clientkeys = gears.table.join(
    awful.key({modkey,}, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),

    awful.key({modkey, "Shift"}, "q", function (c) c:kill() end,
              {description = "close", group = "client"}),

    awful.key({modkey, "Control"}, "space", awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),

    awful.key({modkey, "Control"}, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),

    awful.key({modkey, "Shift"}, "o", function (c) c:move_to_screen() end,
              {description = "move to screen", group = "client"}),

    awful.key({modkey,}, "t", function (c) c.ontop = not c.ontop end,
              {description = "toggle keep on top", group = "client"}),

    awful.key({modkey, "Shift"}, "s", function (c) c.sticky = not c.sticky end,
              {description = "toggle keep on top", group = "client"}),

    awful.key({modkey,}, "n",
        function (c)
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),

    awful.key({modkey,}, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),

    awful.key({modkey, "Control"}, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),

    awful.key({modkey, "Shift"}, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

--------------------------------------------------------------------------------
-- Keys for move between tags
--------------------------------------------------------------------------------
for i = 1, 9 do
    globalkeys = gears.table.join(
        globalkeys,
        awful.key({modkey}, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                            if tag.selected then
                                awful.tag.history.restore()
                            else
                                tag:view_only()
                            end
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),

        awful.key({modkey, "Control"}, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),

        awful.key({modkey, "Shift"}, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),

        awful.key({modkey, "Control", "Shift"}, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

--------------------------------------------------------------------------------
-- Set global keys
--------------------------------------------------------------------------------
root.keys(globalkeys)

--------------------------------------------------------------------------------
-- Rules
--------------------------------------------------------------------------------
awful.rules.rules = {
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },
    {
        rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
            },
            class = {
                "Arandr",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Wpa_gui",
                "pinentry",
                "veromix",
                "Pavucontrol",
                "Galculator",
                "xtightvncviewer",
                "Shutter",
                "Kalu",
                "TelegramDesktop",
                "Nautilus",
                "qjackctl",
                "QjackCtl"
            },
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        }, properties = {floating = true}
    },
    { 
        rule_any = {type = { "normal", "dialog" }},
        properties = { titlebars_enabled = true }
    },
    {
        rule_any = {
            class = {
                "wotblitz.exe",
                "WorldOfTanks.exe"
            }
        },
        properties = {
            border_width = 0
        }
    },
    {
            rule = {
                class = "jetbrains-.*",
            }, properties = { focus = true, buttons = clientbuttons_jetbrains }
    },
    {
            rule = {
                class = "jetbrains-.*",
                name = "win.*"
            }, properties = { titlebars_enabled = false, focusable = false, focus = true, floating = true, placement = awful.placement.restore }
   }
}

--------------------------------------------------------------------------------
-- Signals
--------------------------------------------------------------------------------
client.connect_signal("manage", function (c)
    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

--------------------------------------------------------------------------------
-- Add a titlebar if titlebars_enabled is set to true in the rules.
--------------------------------------------------------------------------------
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

--------------------------------------------------------------------------------
-- Mouse focus => Client focus
--------------------------------------------------------------------------------
-- client.connect_signal("mouse::enter", function(c)
--     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--         and awful.client.focus.filter(c) then
--         client.focus = c
--     end
-- end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

--------------------------------------------------------------------------------
-- Run on start
--------------------------------------------------------------------------------
awful.util.spawn("nm-applet")
awful.util.spawn("blueman-applet")
awful.util.spawn("flameshot")
awful.util.spawn("compton")
awful.util.spawn("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

