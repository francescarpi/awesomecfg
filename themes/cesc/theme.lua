-- Thema Cesc
theme = {}

carpeta_tema = "/home/farpi/.config/awesome/themes/"

theme.wallpaper = carpeta_tema .. "cesc/background.jpg"

-- Definición de colores
theme.bg_normal = "#222222"
theme.bg_focus = "#535d6c"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"
theme.bg_systray = theme.bg_normal

theme.fg_normal = "#aaaaaa"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.border_width = 4
theme.border_normal = "#000000"
theme.border_focus = "#ff0202"
theme.border_marked = "#91231c"

-- Definición de iconos
theme.awesome_icon = carpeta_tema .. "cesc/iconos/principal.png"
theme.sistema_icon = carpeta_tema .. "cesc/iconos/sistema.png"

-- Iconos de tag activo, no activo...
theme.taglist_squares_sel   = carpeta_tema .. "cesc/iconos/tag_on.png"
theme.taglist_squares_unsel = carpeta_tema .. "cesc/iconos/tag_off.png"

-- Layouts
theme.layout_fairh = carpeta_tema .. "cesc/iconos/layouts/fairhw.png"
theme.layout_fairv = carpeta_tema .. "cesc/iconos/layouts/fairvw.png"
theme.layout_floating  = carpeta_tema .. "cesc/iconos/layouts/floatingw.png"
theme.layout_magnifier = carpeta_tema .. "cesc/iconos/layouts/magnifierw.png"
theme.layout_max = carpeta_tema .. "cesc/iconos/layouts/maxw.png"
theme.layout_fullscreen = carpeta_tema .. "cesc/iconos/layouts/fullscreenw.png"
theme.layout_tilebottom = carpeta_tema .. "cesc/iconos/layouts/tilebottomw.png"
theme.layout_tileleft   = carpeta_tema .. "cesc/iconos/layouts/tileleftw.png"
theme.layout_tile = carpeta_tema .. "cesc/iconos/layouts/tilew.png"
theme.layout_tiletop = carpeta_tema .. "cesc/iconos/layouts/tiletopw.png"
theme.layout_spiral  = carpeta_tema .. "cesc/iconos/layouts/spiralw.png"
theme.layout_dwindle = carpeta_tema .. "cesc/iconos/layouts/dwindlew.png"

-- Iconos de widgets
theme.bateria_icon = carpeta_tema .. "cesc/iconos/widgets/bateria.png"
theme.brillo_icon = carpeta_tema .. "cesc/iconos/widgets/brillo.png"
theme.volumen_icon = carpeta_tema .. "cesc/iconos/widgets/volumen.png"
theme.reloj_icon = carpeta_tema .. "cesc/iconos/widgets/reloj.png"

return theme
