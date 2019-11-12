local wibox = require("wibox")
local awful = require("awful")
local gfs = require("gears.filesystem")
local cfg_path = gfs.get_configuration_dir()
local beautiful = require("beautiful")
local gears = require("gears")

local icon = wibox.widget.imagebox()
local text = wibox.widget.textbox()

volume_widget = wibox.layout {
    layout = wibox.layout.fixed.horizontal,
    {
        widget = wibox.container.margin,
        top = 5,
        {
            widget = icon,
            forced_width = 12
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

local function update_value()
    local fd = io.popen("amixer sget Master")
    local stdout = fd:read("*all")
    fd:close()

    local onoff = string.match(stdout, "%[(o[^%]]*)%]")
    local value = tonumber(string.match(stdout, "(%d?%d?%d)%%"))
    text:set_text(" " .. value .. "% ")

    if string.find(onoff, "on", 1, true) then
        text:set_text(" " .. value .. "% ")
        if value >= 0 and value <= 25 then
            icon:set_image(cfg_path.."volume/audio-volume-low.png")
        elseif value > 25 and value <= 75 then
            icon:set_image(cfg_path.."volume/audio-volume-medium.png")
        elseif value> 75 then
            icon:set_image(cfg_path.."volume/audio-volume-high.png")
        end
    else
        icon:set_image(cfg_path.."volume/audio-volume-muted.png")
        text:set_markup_silently(" <span color=\"" .. beautiful.bg_urgent .. "\">M</span> ")
    end
end

update_value()

awful.widget.watch(
    'amixer sget Master', 5,
    function(widget, stdout, stderr, reason, exit_code)
        local onoff = string.match(stdout, "%[(o[^%]]*)%]")
        local value = tonumber(string.match(stdout, "(%d?%d?%d)%%"))
        text:set_text(" " .. value .. "% ")

        if string.find(onoff, "on", 1, true) then
            text:set_text(" " .. value .. "% ")
            if value >= 0 and value <= 25 then
                icon:set_image(cfg_path.."volume/audio-volume-low.png")
            elseif value > 25 and value <= 75 then
                icon:set_image(cfg_path.."volume/audio-volume-medium.png")
            elseif value> 75 then
                icon:set_image(cfg_path.."volume/audio-volume-high.png")
            end
        else
            icon:set_image(cfg_path.."volume/audio-volume-muted.png")
            text:set_markup_silently(" <span color=\"" .. beautiful.bg_urgent .. "\">M</span> ")
        end
    end,
    volume_widget
)

volume_widget:buttons(awful.util.table.join(
    -- right button, toggle mute
    awful.button({}, 3, function ()
        awful.util.spawn("amixer set Master toggle")
        update_value()
    end),

    -- left button, open pavucontrol
    awful.button({}, 1, function ()
        awful.util.spawn('pavucontrol-qt -t 4')
    end),

    -- mouse wheel. inc/dec volum
    awful.button({ }, 4, function()
        awful.util.spawn('amixer set Master 5%+')
        update_value()
    end),
    awful.button({ }, 5, function()
        awful.util.spawn('amixer set Master 5%-')
        update_value()
    end)
))

globalkeys = gears.table.join(globalkeys, awful.key({}, "XF86AudioMute", 
    function()
        awful.util.spawn("amixer set Master toggle")
        update_value()
    end))
globalkeys = gears.table.join(globalkeys, awful.key({}, "XF86AudioRaiseVolume",
    function()
        awful.util.spawn("amixer set Master 5%+")
        update_value()
    end))
globalkeys = gears.table.join(globalkeys, awful.key({}, "XF86AudioLowerVolume",
    function()
        awful.util.spawn("amixer set Master 5%-")
        update_value()
    end))
