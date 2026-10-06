pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root
    // how much of the wallpaper's primary_container to mix into the surfaces
    readonly property real tintAmount: 0.35

    readonly property color background: "{{colors.background.default.hex}}"
    readonly property color on_background: "{{colors.on_background.default.hex}}"

    readonly property color surface: "{{colors.surface.default.hex}}"
    readonly property color on_surface: "{{colors.on_surface.default.hex}}"
    readonly property color surface_variant: "{{colors.surface_variant.default.hex}}"
    readonly property color on_surface_variant: "{{colors.on_surface_variant.default.hex}}"

    readonly property color surface_container_lowest: Qt.tint("{{colors.surface_container_lowest.default.hex}}", Qt.alpha("{{colors.primary_container.default.hex}}", root.tintAmount))
    readonly property color surface_container_low: Qt.tint("{{colors.surface_container_low.default.hex}}", Qt.alpha("{{colors.primary_container.default.hex}}", root.tintAmount))
    readonly property color surface_container: Qt.tint("{{colors.surface_container.default.hex}}", Qt.alpha("{{colors.primary_container.default.hex}}", root.tintAmount))
    readonly property color surface_container_high: Qt.tint("{{colors.surface_container_high.default.hex}}", Qt.alpha("{{colors.primary_container.default.hex}}", root.tintAmount))
    readonly property color surface_container_highest: Qt.tint("{{colors.surface_container_highest.default.hex}}", Qt.alpha("{{colors.primary_container.default.hex}}", root.tintAmount))

    readonly property color surface_tint: "{{colors.surface_tint.default.hex}}"

    readonly property color primary: "{{colors.primary.default.hex}}"
    readonly property color on_primary: "{{colors.on_primary.default.hex}}"
    readonly property color primary_container: "{{colors.primary_container.default.hex}}"
    readonly property color on_primary_container: "{{colors.on_primary_container.default.hex}}"
    readonly property color primary_fixed_dim: "{{colors.primary_fixed_dim.default.hex}}"
    readonly property color on_primary_fixed: "{{colors.on_primary_fixed.default.hex}}"

    readonly property color secondary: "{{colors.secondary.default.hex}}"
    readonly property color on_secondary: "{{colors.on_secondary.default.hex}}"
    readonly property color secondary_container: "{{colors.secondary_container.default.hex}}"
    readonly property color on_secondary_container: "{{colors.on_secondary_container.default.hex}}"

    readonly property color tertiary: "{{colors.tertiary.default.hex}}"
    readonly property color on_tertiary: "{{colors.on_tertiary.default.hex}}"
    readonly property color tertiary_container: "{{colors.tertiary_container.default.hex}}"
    readonly property color on_tertiary_container: "{{colors.on_tertiary_container.default.hex}}"

    readonly property color outline: "{{colors.outline.default.hex}}"
    readonly property color outline_variant: "{{colors.outline_variant.default.hex}}"

    readonly property color error: "{{colors.error.default.hex}}"
    readonly property color on_error: "{{colors.on_error.default.hex}}"
    readonly property color error_container: "{{colors.error_container.default.hex}}"
    readonly property color on_error_container: "{{colors.on_error_container.default.hex}}"

    readonly property color inverse_surface: "{{colors.inverse_surface.default.hex}}"
    readonly property color inverse_on_surface: "{{colors.inverse_on_surface.default.hex}}"
}
