-- WINDOWS AND WORKSPACES

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name = "waywallen-float-center",
    match = {
        class = "(?i).*waywallen.*",    },
    float = true,
    center = true,
    size = { 1200, 652 },
    no_focus = false,})
