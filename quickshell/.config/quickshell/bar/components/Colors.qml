pragma Singleton
import Quickshell
import QtQuick


Singleton {
    id: root

    readonly property var pal: Palettes.build(BarSettings.scheme)
    readonly property real tintAmount: MatugenColors.tintAmount

    function adj(c) {
        const s = BarSettings.saturation
        if (Math.abs(s - 1) < 0.001) return c
        return Qt.hsla(c.hslHue < 0 ? 0 : c.hslHue, Math.min(1, c.hslSaturation * s), c.hslLightness, c.a)
    }

    readonly property color background: root.adj(root.pal ? root.pal.background : MatugenColors.background)
    readonly property color on_background: root.adj(root.pal ? root.pal.on_background : MatugenColors.on_background)
    readonly property color surface: root.adj(root.pal ? root.pal.surface : MatugenColors.surface)
    readonly property color on_surface: root.adj(root.pal ? root.pal.on_surface : MatugenColors.on_surface)
    readonly property color surface_variant: root.adj(root.pal ? root.pal.surface_variant : MatugenColors.surface_variant)
    readonly property color on_surface_variant: root.adj(root.pal ? root.pal.on_surface_variant : MatugenColors.on_surface_variant)
    readonly property color surface_container_lowest: root.adj(root.pal ? root.pal.surface_container_lowest : MatugenColors.surface_container_lowest)
    readonly property color surface_container_low: root.adj(root.pal ? root.pal.surface_container_low : MatugenColors.surface_container_low)
    readonly property color surface_container: root.adj(root.pal ? root.pal.surface_container : MatugenColors.surface_container)
    readonly property color surface_container_high: root.adj(root.pal ? root.pal.surface_container_high : MatugenColors.surface_container_high)
    readonly property color surface_container_highest: root.adj(root.pal ? root.pal.surface_container_highest : MatugenColors.surface_container_highest)
    readonly property color surface_tint: root.adj(root.pal ? root.pal.surface_tint : MatugenColors.surface_tint)
    readonly property color primary: root.adj(root.pal ? root.pal.primary : MatugenColors.primary)
    readonly property color on_primary: root.adj(root.pal ? root.pal.on_primary : MatugenColors.on_primary)
    readonly property color primary_container: root.adj(root.pal ? root.pal.primary_container : MatugenColors.primary_container)
    readonly property color on_primary_container: root.adj(root.pal ? root.pal.on_primary_container : MatugenColors.on_primary_container)
    readonly property color primary_fixed_dim: root.adj(root.pal ? root.pal.primary_fixed_dim : MatugenColors.primary_fixed_dim)
    readonly property color on_primary_fixed: root.adj(root.pal ? root.pal.on_primary_fixed : MatugenColors.on_primary_fixed)
    readonly property color secondary: root.adj(root.pal ? root.pal.secondary : MatugenColors.secondary)
    readonly property color on_secondary: root.adj(root.pal ? root.pal.on_secondary : MatugenColors.on_secondary)
    readonly property color secondary_container: root.adj(root.pal ? root.pal.secondary_container : MatugenColors.secondary_container)
    readonly property color on_secondary_container: root.adj(root.pal ? root.pal.on_secondary_container : MatugenColors.on_secondary_container)
    readonly property color tertiary: root.adj(root.pal ? root.pal.tertiary : MatugenColors.tertiary)
    readonly property color on_tertiary: root.adj(root.pal ? root.pal.on_tertiary : MatugenColors.on_tertiary)
    readonly property color tertiary_container: root.adj(root.pal ? root.pal.tertiary_container : MatugenColors.tertiary_container)
    readonly property color on_tertiary_container: root.adj(root.pal ? root.pal.on_tertiary_container : MatugenColors.on_tertiary_container)
    readonly property color outline: root.adj(root.pal ? root.pal.outline : MatugenColors.outline)
    readonly property color outline_variant: root.adj(root.pal ? root.pal.outline_variant : MatugenColors.outline_variant)
    readonly property color error: root.adj(root.pal ? root.pal.error : MatugenColors.error)
    readonly property color on_error: root.adj(root.pal ? root.pal.on_error : MatugenColors.on_error)
    readonly property color error_container: root.adj(root.pal ? root.pal.error_container : MatugenColors.error_container)
    readonly property color on_error_container: root.adj(root.pal ? root.pal.on_error_container : MatugenColors.on_error_container)
    readonly property color inverse_surface: root.adj(root.pal ? root.pal.inverse_surface : MatugenColors.inverse_surface)
    readonly property color inverse_on_surface: root.adj(root.pal ? root.pal.inverse_on_surface : MatugenColors.inverse_on_surface)
}
