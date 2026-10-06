pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root
    // how much of the wallpaper's primary_container to mix into the surfaces
    readonly property real tintAmount: 0.35

    readonly property color background: "#10140f"
    readonly property color on_background: "#e0e4da"

    readonly property color surface: "#10140f"
    readonly property color on_surface: "#e0e4da"
    readonly property color surface_variant: "#42493f"
    readonly property color on_surface_variant: "#c2c8bd"

    readonly property color surface_container_lowest: Qt.tint("#0b0f0a", Qt.alpha("#255023", root.tintAmount))
    readonly property color surface_container_low: Qt.tint("#191d17", Qt.alpha("#255023", root.tintAmount))
    readonly property color surface_container: Qt.tint("#1d211b", Qt.alpha("#255023", root.tintAmount))
    readonly property color surface_container_high: Qt.tint("#272b25", Qt.alpha("#255023", root.tintAmount))
    readonly property color surface_container_highest: Qt.tint("#323630", Qt.alpha("#255023", root.tintAmount))

    readonly property color surface_tint: "#a2d399"

    readonly property color primary: "#a2d399"
    readonly property color on_primary: "#0c390e"
    readonly property color primary_container: "#255023"
    readonly property color on_primary_container: "#bdf0b3"
    readonly property color primary_fixed_dim: "#a2d399"
    readonly property color on_primary_fixed: "#002203"

    readonly property color secondary: "#baccb3"
    readonly property color on_secondary: "#253423"
    readonly property color secondary_container: "#3b4b38"
    readonly property color on_secondary_container: "#d6e8ce"

    readonly property color tertiary: "#a0cfd3"
    readonly property color on_tertiary: "#00363b"
    readonly property color tertiary_container: "#1e4d52"
    readonly property color on_tertiary_container: "#bcebf0"

    readonly property color outline: "#8c9388"
    readonly property color outline_variant: "#42493f"

    readonly property color error: "#ffb4ab"
    readonly property color on_error: "#690005"
    readonly property color error_container: "#931d25"
    readonly property color on_error_container: "#ffdad6"

    readonly property color inverse_surface: "#e0e4da"
    readonly property color inverse_on_surface: "#2d322b"
}
