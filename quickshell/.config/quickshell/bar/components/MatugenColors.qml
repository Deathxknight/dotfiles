pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root
    // how much of the wallpaper's primary_container to mix into the surfaces
    readonly property real tintAmount: 0.35

    readonly property color background: "#19120d"
    readonly property color on_background: "#f0dfd6"

    readonly property color surface: "#19120d"
    readonly property color on_surface: "#f0dfd6"
    readonly property color surface_variant: "#52443b"
    readonly property color on_surface_variant: "#d6c3b7"

    readonly property color surface_container_lowest: Qt.tint("#140d08", Qt.alpha("#6d3f16", root.tintAmount))
    readonly property color surface_container_low: Qt.tint("#221a15", Qt.alpha("#6d3f16", root.tintAmount))
    readonly property color surface_container: Qt.tint("#261e18", Qt.alpha("#6d3f16", root.tintAmount))
    readonly property color surface_container_high: Qt.tint("#312822", Qt.alpha("#6d3f16", root.tintAmount))
    readonly property color surface_container_highest: Qt.tint("#3c332d", Qt.alpha("#6d3f16", root.tintAmount))

    readonly property color surface_tint: "#ffb783"

    readonly property color primary: "#ffb783"
    readonly property color on_primary: "#4f2500"
    readonly property color primary_container: "#6d3f16"
    readonly property color on_primary_container: "#ffdcc5"
    readonly property color primary_fixed_dim: "#ffb783"
    readonly property color on_primary_fixed: "#301400"

    readonly property color secondary: "#e4bfa7"
    readonly property color on_secondary: "#422b1b"
    readonly property color secondary_container: "#5b412f"
    readonly property color on_secondary_container: "#ffdcc5"

    readonly property color tertiary: "#c8ca94"
    readonly property color on_tertiary: "#30330b"
    readonly property color tertiary_container: "#474920"
    readonly property color on_tertiary_container: "#e4e6ae"

    readonly property color outline: "#9f8d83"
    readonly property color outline_variant: "#52443b"

    readonly property color error: "#ffb4ab"
    readonly property color on_error: "#690005"
    readonly property color error_container: "#931d25"
    readonly property color on_error_container: "#ffdad6"

    readonly property color inverse_surface: "#f0dfd6"
    readonly property color inverse_on_surface: "#382f29"
}
