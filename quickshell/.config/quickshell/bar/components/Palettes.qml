pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property var list: [
        { id: "matugen",    name: "Matugen" },
        { id: "gruvbox",    name: "Gruvbox" },
        { id: "catppuccin", name: "Catppuccin" },
        { id: "nord",       name: "Nord" },
        { id: "tokyonight", name: "Tokyo Night" },
        { id: "rosepine",   name: "Ros\u00e9 Pine" },
        { id: "dracula",    name: "Dracula" }
    ]

    readonly property var bases: ({
        gruvbox:    { bg: "#282828", fg: "#ebdbb2", primary: "#fabd2f", secondary: "#8ec07c", tertiary: "#fe8019", error: "#fb4934" },
        catppuccin: { bg: "#1e1e2e", fg: "#cdd6f4", primary: "#cba6f7", secondary: "#89b4fa", tertiary: "#a6e3a1", error: "#f38ba8" },
        nord:       { bg: "#2e3440", fg: "#eceff4", primary: "#88c0d0", secondary: "#81a1c1", tertiary: "#a3be8c", error: "#bf616a" },
        tokyonight: { bg: "#1a1b26", fg: "#c0caf5", primary: "#7aa2f7", secondary: "#bb9af7", tertiary: "#9ece6a", error: "#f7768e" },
        rosepine:   { bg: "#191724", fg: "#e0def4", primary: "#c4a7e7", secondary: "#9ccfd8", tertiary: "#f6c177", error: "#eb6f92" },
        dracula:    { bg: "#282a36", fg: "#f8f8f2", primary: "#bd93f9", secondary: "#8be9fd", tertiary: "#50fa7b", error: "#ff5555" }
    })

    function mix(a, b, t) {
        return Qt.rgba(a.r + (b.r - a.r) * t,
                       a.g + (b.g - a.g) * t,
                       a.b + (b.b - a.b) * t, 1)
    }

    function build(id) {
        const b = bases[id]
        if (!b) return null
        const black = Qt.color("#000000")
        const white = Qt.color("#ffffff")
        const bg = Qt.color(b.bg)
        const fg = Qt.color(b.fg)
        const dark = mix(bg, black, 0.35)
        const r = {}
        r.background = bg; r.on_background = fg
        r.surface = bg; r.on_surface = fg
        r.surface_variant = mix(bg, fg, 0.18)
        r.on_surface_variant = mix(fg, bg, 0.2)
        r.surface_container_lowest = mix(bg, black, 0.25)
        r.surface_container_low = mix(bg, fg, 0.03)
        r.surface_container = mix(bg, fg, 0.06)
        r.surface_container_high = mix(bg, fg, 0.09)
        r.surface_container_highest = mix(bg, fg, 0.12)
        const accents = ["primary", "secondary", "tertiary", "error"]
        for (let i = 0; i < accents.length; i++) {
            const name = accents[i]
            const c = Qt.color(b[name])
            r[name] = c
            r["on_" + name] = dark
            r[name + "_container"] = mix(bg, c, 0.35)
            r["on_" + name + "_container"] = mix(c, white, 0.55)
        }
        r.surface_tint = r.primary
        r.primary_fixed_dim = r.primary
        r.on_primary_fixed = mix(dark, r.primary, 0.1)
        r.outline = mix(bg, fg, 0.5)
        r.outline_variant = mix(bg, fg, 0.25)
        r.inverse_surface = fg
        r.inverse_on_surface = bg
        return r
    }
}
