local wibox     = require("wibox")
local awful     = require("awful")
local gfs       = require("gears.filesystem")
local cfg_path  = gfs.get_configuration_dir()
local beautiful = require("beautiful")

local text = wibox.widget.textbox()

local function set_brightness(value)
    awful.util.spawn("xbacklight -set " .. value)
end

screen_widget = wibox.layout {
    layout = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        left = 10,
        {
            widget = wibox.widget.textbox,
            markup = "<span color='#d71eb8'></span>",
            font = 'Fontawesome 10'
        }
    },
    {
        widget = wibox.container.margin,
        left = 2,
        {
            widget = text,
            font = beautiful.font
        }
    }
}

local function get_bright()
    os.execute("sleep .2")
    local fd = io.popen("xbacklight -get")
    local value = fd:read("*all")
    value = tonumber(value)
    fd:close()
    if value == nil then
	    return "0"
    end
    percent = string.format("%.0f", value)
    return percent
end

local function update_screen()
    text:set_text(" " .. get_bright() .. "% ")
end

local function brightness_toggle()
    percent = get_bright()

    if percent == "100" then
        awful.util.spawn("xbacklight -set 15")
    elseif percent == "15" then
        awful.util.spawn("xbacklight -set 30")
    elseif percent == "30" then
        awful.util.spawn("xbacklight -set 50")
    elseif percent == "50" then
        awful.util.spawn("xbacklight -set 75")
    else
        awful.util.spawn("xbacklight -set 100")
    end
end

update_screen()

local menu_theme = {
    height = 30,
    width = 220,
    border_width = 3,
    border_color = '#D50000',
    font = 'Verdana Bold 10'
}

local menu = awful.menu({
    items = {
        { "Brightness to 100%", function() set_brightness('100') update_screen() end },
        { "Brightness to 75%", function() set_brightness('75') update_screen() end },
        { "Brightness to 50%", function() set_brightness('50') update_screen() end },
        { "Brightness to 30%", function() set_brightness('30') update_screen() end },
        { "Brightness to 15%", function() set_brightness('15') update_screen() end },
        { "-------", function() end },
        { "Two monitors", function() awful.util.spawn("xrandr --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI1 --primary --mode 1920x1200 --pos 1920x0 --rotate normal --output VIRTUAL1 --off") end },
        { "One monitor", function() awful.util.spawn("ixrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI1 --off --output VIRTUAL1 --off") end },
    },
    theme = menu_theme,
})

screen_widget:buttons(awful.util.table.join(

    awful.button({ }, 1, function ()
        menu:toggle()
    end),

    awful.button({ }, 5, function ()
        awful.util.spawn("xbacklight -dec 10")
        update_screen()
    end),

    awful.button({ }, 4, function ()
        awful.util.spawn("xbacklight -inc 10")
        update_screen()
    end)

))

globalkeys = awful.util.table.join(globalkeys, awful.key({}, "XF86MonBrightnessDown", function() awful.util.spawn("xbacklight -dec 10") update_screen() end))
globalkeys = awful.util.table.join(globalkeys, awful.key({}, "XF86MonBrightnessUp", function() awful.util.spawn("xbacklight -inc 10") update_screen() end))
