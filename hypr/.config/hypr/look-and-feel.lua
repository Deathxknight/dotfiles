local colors_path = os.getenv("HOME") .. "/.cache/matugen/hypr-colors.lua"
local ok, wal_colors = pcall(dofile, colors_path)
if not ok then
    wal_colors = {
        on_background = "0xffffffff",
        surface        = "0xff1a1a1a",
    }
end

hl.config({
    general = {
        gaps_in  = 7,
        gaps_out = 13,
        border_size = 2,
        col = {
            active_border   = wal_colors.inverse_primary or wal_colors.on_background,
            inactive_border = wal_colors.background or wal_colors.surface,
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },
    decoration = {
        rounding         = 15,
        rounding_power   = 2,
        active_opacity   = 1,
        inactive_opacity = 1,
        dim_inactive     = false,
        shadow = {
            enabled      = true,
            range        = 10,
            render_power = 3,
            color        = 0xee1a1a1a,
        },
        blur = {
            enabled        = true,
            size           = 9,
            passes         = 3,
            ignore_opacity = true,
            xray           = false,
            vibrancy       = 0.1696,
        },
    },
    animations = {
        enabled = true,
    },
    ecosystem = {
        no_update_news = true,
    },
})


-- wofi layer rules
hl.layer_rule({
    name  = "wofi-blur",
    match = { namespace = "wofi" },
    blur  = true,
})

hl.layer_rule({
    name    = "wofi-no-anim",
    match   = { namespace = "wofi" },
    no_anim = true,
})

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- Master layout (unused while general.layout = dwindle)
hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    misc = {
        animate_mouse_windowdragging = false,
        disable_hyprland_logo        = true,
        disable_splash_rendering     = true,
        enable_swallow               = true,
        swallow_regex                = "^(Alacritty|kitty|footclient|brave-browser)$",
        force_default_wallpaper      = -1,
    },
})
