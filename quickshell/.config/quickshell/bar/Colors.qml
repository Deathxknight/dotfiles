pragma Singleton
import Quickshell
import QtQuick

Singleton {
    readonly property color background: "#141312"
    readonly property color on_background: "#e5e2df"

    readonly property color surface: "#141312"
    readonly property color on_surface: "#e5e2df"
    readonly property color surface_variant: "#464740"
    readonly property color on_surface_variant: "#c7c7bd"

    readonly property color surface_container_lowest: "#0e0e0d"
    readonly property color surface_container_low: "#1c1c1a"
    readonly property color surface_container: "#20201e"
    readonly property color surface_container_high: "#2a2a29"
    readonly property color surface_container_highest: "#353533"

    readonly property color surface_tint: "#c6c8b7"

    readonly property color primary: "#c6c8b7"
    readonly property color on_primary: "#2f3226"
    readonly property color primary_container: "#1c1f14"
    readonly property color on_primary_container: "#a8aa9a"
    readonly property color primary_fixed_dim: "#c6c8b7"
    readonly property color on_primary_fixed: "#1a1d12"

    readonly property color secondary: "#c8c7be"
    readonly property color on_secondary: "#30312b"
    readonly property color secondary_container: "#4b4c45"
    readonly property color on_secondary_container: "#e9e8df"

    readonly property color tertiary: "#d2c2cc"
    readonly property color on_tertiary: "#372d35"
    readonly property color tertiary_container: "#241b22"
    readonly property color on_tertiary_container: "#b4a5ae"

    readonly property color outline: "#919188"
    readonly property color outline_variant: "#464740"

    readonly property color error: "#ffb4ab"
    readonly property color on_error: "#690005"
    readonly property color error_container: "#93000a"
    readonly property color on_error_container: "#ffdad6"

    readonly property color inverse_surface: "#e5e2df"
    readonly property color inverse_on_surface: "#31302f"
}
