local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gfs = require("gears.filesystem")
local cfg_path = gfs.get_configuration_dir()

local text = wibox.widget.textbox('Off')

touchpad_widget = wibox.layout {
    layout = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        right = 5,
        left = 5,
        {
            widget = wibox.widget.textbox,
            markup = "<span color='#3e1ed7'></span>",
            font = 'Fontawesome 10'
        }
    },
    {
        widget = wibox.container.margin,
        {
            widget = text,
            font = beautiful.font
        },
    },
}

local function get_value()
    local fd = io.popen('xinput --list-props 12 | grep -i "tapping enabled (" | awk \'{ print $5 }\'')
    local status = fd:read('*all')
    fd:close()
    local value = tonumber(status)
    return value
end

local function update_value()
    if get_value() == 0 then
        text:set_text('Off')
    else
        text:set_text('On')
    end
end

touchpad_widget:buttons(awful.util.table.join(
    awful.button({}, 1, function()
        if get_value() == 0 then
            awful.util.spawn('xinput --set-prop 12 321 1')
        else
            awful.util.spawn('xinput --set-prop 12 321 0')
        end
        update_value()
    end)
))

awful.util.spawn('xinput --set-prop 12 321 0')
update_value()
