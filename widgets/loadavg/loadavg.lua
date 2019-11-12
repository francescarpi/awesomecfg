local wibox = require("wibox")
local awful = require("awful")
local gfs = require("gears.filesystem")
local cfg_path = gfs.get_configuration_dir()
local beautiful = require("beautiful")

local text = wibox.widget.textbox()

loadavg_widget = wibox.layout {
    layout = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        top = 4,
        left = 5,
        {
            widget = wibox.widget.imagebox,
            image = cfg_path .. "loadavg/loadavg.png",
            forced_width = 13
        }
    },
    {
        widget = wibox.container.margin,
        left = 5,
        text
    }
}

awful.widget.watch(
    'cat /proc/loadavg', 1,
    function(widget, stdout, stderr, reason, exit_code)
        local value = string.match(stdout, "[%d]*%.[%d]*")
        local vnumber = tonumber(value)
        local tnumber = string.format("%.2f", vnumber)

        if vnumber > 3 then
            text:set_markup_silently("<span color=\"" .. beautiful.bg_urgent .. "\">" .. tnumber .. "</span>")
        else
            text:set_text(tnumber)
        end
    end,
    loadavg_widget
)