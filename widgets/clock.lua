local wibox     = require("wibox")
local gfs       = require("gears.filesystem")
local cfg_path  = gfs.get_configuration_dir()
local beautiful = require("beautiful")
local awful     = require("awful")

clock_widget = wibox.layout {
    layout = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        left = 10,
        {
            widget = wibox.widget.textbox,
            markup = "<span color='#d7a71e'></span>",
            font = 'Fontawesome 10'
        }
    },
    {
        widget = wibox.container.margin,
        left = 5,
        right = 10,
        wibox.widget.textclock("%d/%m/%Y")
    },
    {
        widget = wibox.container.margin,
        {
            widget = wibox.widget.textbox,
            markup = "<span color='#8fd71e'></span>",
            font = 'Fontawesome 10'
        }
    },
    {
        widget = wibox.container.margin,
        left = 5,
        {
            widget = wibox.widget.textclock("%H:%M"),
            font = beautiful.font
        }
    },
}

clock_widget:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        awful.util.spawn('zenity --calendar')
    end)
))
