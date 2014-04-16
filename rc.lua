-- Configuración Cesc
local gears = require("gears")

local awful = require("awful")
awful.rules = require("awful.rules")

require("awful.autofocus")

local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")

local io = { open = io.open, popen = io.popen }
local tonumber = tonumber

-- Si al arrancar hay un error...
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "¡Vaya, ya te has cargado algo!",
        text = awesome.startup_errors
    })
end

-- Handle que notifica de errores una vez ha arrancado todo...
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "¡Mira que eres manazas, eh!",
            text = err
        })
        in_error = false
    end)
end

-- Cargamos tema visual i wallpapers...
beautiful.init("/home/farpi/.config/awesome/themes/cesc/theme.lua")

if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end

-- Definición del terminal, editor y tecla de disparo principal...
terminal = "terminator"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

-- Layouts activados
local layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.right,
}

-- Número de tags o escritorio para cada monitor. Distingo si sólo tengo un monitor,
-- es decir sólo el portátil, o portátil con pantalla externa
tags = {}

if screen.count() == 1 then
    tags[1] = awful.tag({ 1, 2, 3, 4, 5 }, 1, layouts[2])
else
    tags[2] = awful.tag({ 1, 2, 3, 4, 5}, 2, layouts[3])
    tags[1] = awful.tag({ 1, 2, 3, 4, 5 }, 1, layouts[2])
end

-- Opciones del menú...
myawesomemenu = {
   { "Reiniciar", awesome.restart },
   { "Salir", awesome.quit }
}

sistemamenu = {
    {"Bloquear", terminal .. " -e slock"},
    {"Suspender", terminal .. " -e beesu pm-suspend"},
    {"Apagar", terminal .. " -e shutdown -h now"},
    {"Reiniciar", terminal .. " -e shutdown -r now"}
}

mymainmenu = awful.menu({
    items = {
        {"Awesome", myawesomemenu, beautiful.awesome_icon},
        {"Sistema", sistemamenu, beautiful.sistema_icon},
    }
})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

menubar.utils.terminal = terminal 

-- Widgets
function round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

-- Hora
fecha_text = awful.widget.textclock(' %d/%m %H:%M  ')
fecha_widget = wibox.widget.background()
fecha_widget:set_widget(fecha_text)
fecha_widget:set_bg('#6a450a')

reloj_icon = wibox.widget.imagebox()
reloj_icon:set_image(beautiful.reloj_icon)
reloj_icon_widget = wibox.widget.background()
reloj_icon_widget:set_widget(reloj_icon)
reloj_icon_widget:set_bg('#6a450a')

fecha_widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn('gnome-control-center') end)
))

-- Bateria
-- Muestra estado de la batería. Si hacemos clic sobre el texto, se
-- actualiza
bateria_text = wibox.widget.textbox()
bateria_widget = wibox.widget.background()
bateria_widget:set_widget(bateria_text)
bateria_widget:set_bg('#3b6a0a')

bateria_icon = wibox.widget.imagebox()
bateria_icon:set_image(beautiful.bateria_icon)
bateria_icon_widget = wibox.widget.background()
bateria_icon_widget:set_widget(bateria_icon)
bateria_icon_widget:set_bg('#3b6a0a')

function actualiza_estado_bateria()
    local f = io.open("/sys/class/power_supply/BAT1/capacity")
    local estado = f:read("*all")
    f:close()

    bateria_text:set_text(string.format("%d%% ", estado))
end

actualiza_estado_bateria()

bateria_widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () actualiza_estado_bateria() end)
))
-- Final widget bateria

-- Brillo
-- Muestra el porcentaje del brillo de la pantalla
brillo_txt = wibox.widget.textbox()
brillo_widget = wibox.widget.background()
brillo_widget:set_widget(brillo_txt)
brillo_widget:set_bg('#6a0a50')

brillo_icon = wibox.widget.imagebox()
brillo_icon:set_image(beautiful.brillo_icon)
brillo_icon_widget = wibox.widget.background()
brillo_icon_widget:set_widget(brillo_icon)
brillo_icon_widget:set_bg('#6a0a50')

function brillo_actual()
    local f = io.popen("xbacklight -get")
    local actual = f:read("*all")
    f:close()
    return tonumber(actual)
end

function actualiza_brillo()
    local actual = brillo_actual()
    brillo_txt:set_text(string.format(" %d%% ", round(actual)))
end

function subir_bajar_brillo(tipo)
    local actual = brillo_actual()

    if tipo == 'inc' or (tipo == 'dec' and actual > 15) then
        local cmd = string.format("xbacklight -%s 5", tipo)
        os.execute(cmd)
    end
    actualiza_brillo()
end

actualiza_brillo()

brillo_widget:buttons(awful.util.table.join(
    awful.button({ }, 4, function () subir_bajar_brillo('inc') end),
    awful.button({ }, 5, function () subir_bajar_brillo('dec') end)
))
-- Final brillo

-- Volumen
-- Indicamos porcentaje de volumen
volumen_text = wibox.widget.textbox()
volumen_widget = wibox.widget.background()
volumen_widget:set_widget(volumen_text)
volumen_widget:set_bg('#2c0a6a')

volumen_icon = wibox.widget.imagebox()
volumen_icon:set_image(beautiful.volumen_icon)
volumen_icon_widget = wibox.widget.background()
volumen_icon_widget:set_widget(volumen_icon)
volumen_icon_widget:set_bg('#2c0a6a')

function volumen_actual()
    local f = io.popen("amixer -M get Master")
    local datos = f:read("*all")
    f:close()

    local volumen, mute = string.match(datos, "([%d]+)%%.*%[([%l]*)")

    return volumen, mute
end

function actualiza_volumen()
    local actual, mute = volumen_actual()
    if mute == 'on' then
        volumen_text:set_text(string.format(" %d%% ", actual))
    else
        volumen_text:set_text(" MUTE ")
    end
end

function subir_bajar_volumen(tipo)
    if tipo == 'inc' then
        signo = '+'
    else
        signo = '-'
    end

    local cmd = string.format("amixer set Master 1%%%s", signo)
    os.execute(cmd)

    actualiza_volumen()
end

function toggle_volumen()
    -- Pasa de mute a no mute
    local cmd = string.format("amixer set Master toggle")
    os.execute(cmd)

    actualiza_volumen()
end

actualiza_volumen()

volumen_widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () actualiza_volumen() end),
    awful.button({ }, 3, function () toggle_volumen() end),
    awful.button({ }, 4, function () subir_bajar_volumen('inc') end),
    awful.button({ }, 5, function () subir_bajar_volumen('dec') end)
))
-- Final volumen

-- Wifi
-- Indica si el wifi está acxtivado, o no.
wifi_text = wibox.widget.textbox()
wifi_widget = wibox.widget.background()
wifi_widget:set_widget(wifi_text)
wifi_widget:set_bg('#6a0a0a')

function actualizar_wifi()
    local f = io.popen("iwconfig wlp2s0")
    local datos = f:read("*all")
    f:close()

    local essid = string.match(datos, 'ESSID[=:]"(.-)"')

    if essid then
        wifi_text:set_text(' ' .. essid .. ' ')
    else
        wifi_text:set_text(' NO WIFI ')
    end
end

actualizar_wifi()

wifi_widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () actualizar_wifi() end)
))

-- Final wifi

-- Menú de superior para cada tag...
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}

-- Comportamiento del ratón...
mytasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
                          if c == client.focus then
                              c.minimized = true
                          else
                              -- Without this, the following
                              -- :isvisible() makes no sense
                              c.minimized = false
                              if not c:isvisible() then
                                  awful.tag.viewonly(c:tags()[1])
                              end
                              -- This will also un-minimize
                              -- the client, if needed
                              client.focus = c
                              c:raise()
                          end
                      end),
    awful.button({ }, 3, function ()
                          if instance then
                              instance:hide()
                              instance = nil
                          else
                              instance = awful.menu.clients({ width=250 })
                          end
                      end),
    awful.button({ }, 4, function ()
                          awful.client.focus.byidx(1)
                          if client.focus then client.focus:raise() end
                      end),
    awful.button({ }, 5, function ()
                          awful.client.focus.byidx(-1)
                          if client.focus then client.focus:raise() end
                      end)
)

for s = 1, screen.count() do
    mypromptbox[s] = awful.widget.prompt()
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    
    -- Creación de la lista de tags o escritorios..
    mytaglist[s] = awful.widget.taglist(s,
        awful.widget.taglist.filter.all,
        mytaglist.buttons)

    -- Lista de aplicaciones abiertas
    mytasklist[s] = awful.widget.tasklist(s,
        awful.widget.tasklist.filter.currenttags,
        mytasklist.buttons)

    -- Creación del wibox, o menú superior...
    mywibox[s] = awful.wibox({ position = "top", screen = s})

    -- Widgets alineados a la izquierda
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets alineados a la derecha
    local right_layout = wibox.layout.fixed.horizontal()

    -- El widget de iconos del sistema sólo lo añadimos a un monitor
    if screen.count() == 1 then
      right_layout:add(wibox.widget.systray())
    else
      if s == 2 then
        right_layout:add(wibox.widget.systray())
      end
    end

    right_layout:add(bateria_icon_widget)
    right_layout:add(bateria_widget)

    right_layout:add(brillo_icon_widget)
    right_layout:add(brillo_widget)

    right_layout:add(volumen_icon_widget)
    right_layout:add(volumen_widget)

    right_layout:add(wifi_widget)

    right_layout:add(reloj_icon_widget)
    right_layout:add(fecha_widget)

    right_layout:add(mylayoutbox[s])

    -- Se coloca cada componente en el wibox
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}


-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)

    -- awful.key({ modkey }, "d",
    --     function()
    --         prova.text = "hola"
    --     end)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),

    -- Al  pulsar modkoey + a, devuelve el foco a la ventana que tengamos debajo
    -- del ratón
    awful.key({ modkey }, "a",
        function(c)
            c:raise()
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- Reglas de aplicaciones...
awful.rules.rules = {
    -- Todas las aplicaciones
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    -- Aplicaciones específicas
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { instance = "pavucontrol" },
      properties = { floating = true } },
    { rule = { instance = "yad" },
      properties = { floating = true } },
    { rule = { instance = "nautilus" },
      properties = { floating = true } },
}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
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

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
--

-- Arrancar en el inicio...
autorun = true
autorunApps = 
{ 
   "dropbox start"
}
if autorun then
   for app = 1, #autorunApps do
       awful.util.spawn(autorunApps[app])
   end
end
