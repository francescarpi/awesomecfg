local wibox     = require("wibox")
local gfs       = require("gears.filesystem")
local cfg_path  = gfs.get_configuration_dir()
local beautiful = require("beautiful")
local awful     = require("awful")

clock_widget = wibox.layout {
    layout = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        top = 4,
        left = 10,
        {
            widget = wibox.widget.imagebox,
            image = cfg_path .. "widgets/clock/calendar.png",
            forced_width = 13
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
        top = 4,
        {
            widget = wibox.widget.imagebox,
            image = cfg_path .."widgets/clock/clock.png",
            forced_width = 13
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
