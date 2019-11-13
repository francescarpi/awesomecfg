
local theme_assets          = require("beautiful.theme_assets")
local xresources            = require("beautiful.xresources")
local dpi                   = xresources.apply_dpi
local gears                 = require("gears")

local gfs                   = require("gears.filesystem")
local themes_path           = gfs.get_configuration_dir()

local theme                 = {}

theme.font                  = "Verdana Bold 8"

theme.bg_normal             = "#000000"
theme.bg_focus              = "#546e7a"
theme.bg_urgent             = "#d50000"
theme.bg_minimize           = theme.bg_normal
theme.bg_systray            = theme.bg_normal

theme.fg_normal             = "#828282"
theme.fg_focus              = "#ffffff"
theme.fg_urgent             = "#ffffff"
theme.fg_minimize           = "#505050"

theme.useless_gap           = 5
theme.border_width          = dpi(3)
theme.border_normal         = theme.bg_normal
theme.border_focus          = theme.bg_urgent
theme.border_marked         = "#91231c"

theme.menu_submenu_icon     = themes_path.."theme/submenu.png"
theme.menu_height           = dpi(15)
theme.menu_width            = dpi(100)

theme.wallpaper             = themes_path.."theme/background.jpg"

theme.layout_fairh          = themes_path.."theme/layouts/fairh.png"
theme.layout_fairv          = themes_path.."theme/layouts/fairv.png"
theme.layout_floating       = themes_path.."theme/layouts/floating.png"
theme.layout_magnifier      = themes_path.."theme/layouts/magnifier.png"
theme.layout_max            = themes_path.."theme/layouts/max.png"
theme.layout_fullscreen     = themes_path.."theme/layouts/fullscreen.png"
theme.layout_tilebottom     = themes_path.."theme/layouts/tilebottom.png"
theme.layout_tileleft       = themes_path.."theme/layouts/tileleft.png"
theme.layout_tile           = themes_path.."theme/layouts/tile.png"
theme.layout_tiletop        = themes_path.."theme/layouts/tiletop.png"
theme.layout_spiral         = themes_path.."theme/layouts/spiral.png"
theme.layout_dwindle        = themes_path.."theme/layouts/dwindle.png"
theme.layout_cornernw       = themes_path.."theme/layouts/cornernw.png"
theme.layout_cornerne       = themes_path.."theme/layouts/cornerne.png"
theme.layout_cornersw       = themes_path.."theme/layouts/cornersw.png"
theme.layout_cornerse       = themes_path.."theme/layouts/cornerse.png"

-- titlebar
theme.titlebar_close_button_focus               = themes_path .. "theme/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = themes_path .. "theme/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active        = themes_path .. "theme/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = themes_path .. "theme/titlebar/ontop_normal_active.png"

theme.titlebar_ontop_button_focus_inactive      = themes_path .. "theme/titlebar/ontop_focus_inactive.svg"
theme.titlebar_ontop_button_normal_inactive     = themes_path .. "theme/titlebar/ontop_normal_inactive.svg"

theme.titlebar_sticky_button_focus_active       = themes_path .. "theme/titlebar/sticky_focus_active.svg"
theme.titlebar_sticky_button_normal_active      = themes_path .. "theme/titlebar/sticky_normal_active.svg"

theme.titlebar_sticky_button_focus_inactive     = themes_path .. "theme/titlebar/sticky_focus_inactive.svg"
theme.titlebar_sticky_button_normal_inactive    = themes_path .. "theme/titlebar/sticky_normal_inactive.svg"

theme.titlebar_floating_button_focus_active     = themes_path .. "theme/titlebar/floating_focus_active.svg"
theme.titlebar_floating_button_normal_active    = themes_path .. "theme/titlebar/floating_normal_active.svg"

theme.titlebar_floating_button_focus_inactive   = themes_path .. "theme/titlebar/floating_focus_inactive.svg"
theme.titlebar_floating_button_normal_inactive  = themes_path .. "theme/titlebar/floating_normal_inactive.svg"

theme.titlebar_maximized_button_focus_active    = themes_path .. "theme/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = themes_path .. "theme/titlebar/maximized_normal_active.png"

theme.titlebar_maximized_button_focus_inactive  = themes_path .. "theme/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themes_path .. "theme/titlebar/maximized_normal_inactive.png"

theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height,
    theme.bg_normal,
    theme.fg_normal
)

-- theme.tasklist_disable_icon = true
theme.tasklist_font         = "Verdana 8"

local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size,
    "#FFFFFF"
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size,
    "#FFFFFF"
)

-- Naughty
theme.naughty_icon_size = 22
-- TODO : Fix this external call
local naughty = require("naughty")
naughty.config.presets.normal.bg = theme.bg_normal
naughty.config.presets.normal.fg = theme.fg_normal
naughty.config.presets.normal.border_color = theme.fg_normal

naughty.config.presets.low.bg = theme.bg_normal
naughty.config.presets.low.fg = theme.fg_normal
naughty.config.presets.low.border_color = theme.bg_normal

naughty.config.presets.critical.bg = theme.bg_urgent
naughty.config.presets.critical.fg = theme.fg_urgent
naughty.config.presets.critical.border_color = theme.fg_urgent

theme.titlebar_bg = '#000000'

return theme
