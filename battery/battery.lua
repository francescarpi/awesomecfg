local wibox = require("wibox")
local awful = require("awful")
local gfs = require("gears.filesystem")
local cfg_path = gfs.get_configuration_dir()
local beautiful = require("beautiful")

local text = wibox.widget.textbox()
local icon = wibox.widget.imagebox()

battery_widget = wibox.layout {
    layout = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        top = 2,
        left = 5,
        {
            widget = icon,
            forced_width = 17
        }
    },
    {
        widget = wibox.container.margin,
        right = 5,
        text
    }
}

awful.widget.watch(
    'acpi',
    60,
    function(widget, stdout, stderr, reason, exit_code)
        local percent = tonumber(string.match(stdout, "(%d?%d?%d)%%"))
        local color = beautiful.fg_normal
        local is_charging = string.find(stdout, "Charging") ~= nil
        local append_text = ""

        if is_charging then
            append_text = '+'
        end

        if percent < 10 then
            color = beautiful.bg_urgent
        end

        local pbar = {"-","-","-","-","-","-","-","-","-","-"}
        for i=1,math.floor((percent/10)) do pbar[i] ="█" end
        text:set_markup_silently(" <span color=\"" .. color .. "\">" .. table.concat(pbar,"") .. " (" .. percent .. "%)" .. append_text .. "</span> ")

        if is_charging then
        end

        if percent >= 0 and percent <= 5 then
            icon:set_image(cfg_path.."battery/battery-caution.png")
        elseif percent > 5 and percent <= 50 then
            icon:set_image(cfg_path.."battery/battery-low.png")
        elseif percent > 50 and percent <= 75 then
            icon:set_image(cfg_path.."battery/battery-good.png")
        elseif percent > 75 then
            icon:set_image(cfg_path.."battery/battery-full.png")
        end
    end,
    battery_widget
)
