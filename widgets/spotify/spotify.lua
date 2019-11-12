local wibox = require("wibox")
local awful = require("awful")
local gfs = require("gears.filesystem")
local cfg_path = gfs.get_configuration_dir()

spotify_widget = wibox.layout {
    layout = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        top = 4,
        left = 5,
        right = 5,
        {
            widget = wibox.widget.imagebox,
            image = cfg_path .. "spotify/spotify.png",
            forced_width = 13
        }
    }
}

spotify_widget:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
    end)
))
