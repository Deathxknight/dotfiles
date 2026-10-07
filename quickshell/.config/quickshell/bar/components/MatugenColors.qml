pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root
    // how much of the wallpaper's primary_container to mix into the surfaces
    readonly property real tintAmount: 0.35

    readonly property color background: "#1a1112"
    readonly property color on_background: "#f0dedf"

    readonly property color surface: "#1a1112"
    readonly property color on_surface: "#f0dedf"
    readonly property color surface_variant: "#524344"
    readonly property color on_surface_variant: "#d7c1c3"

    readonly property color surface_container_lowest: Qt.tint("#140c0d", Qt.alpha("#72333d", root.tintAmount))
    readonly property color surface_container_low: Qt.tint("#22191a", Qt.alpha("#72333d", root.tintAmount))
    readonly property color surface_container: Qt.tint("#261d1e", Qt.alpha("#72333d", root.tintAmount))
    readonly property color surface_container_high: Qt.tint("#312828", Qt.alpha("#72333d", root.tintAmount))
    readonly property color surface_container_highest: Qt.tint("#3d3233", Qt.alpha("#72333d", root.tintAmount))

    readonly property color surface_tint: "#ffb2bb"

    readonly property color primary: "#ffb2bb"
    readonly property color on_primary: "#561d27"
    readonly property color primary_container: "#72333d"
    readonly property color on_primary_container: "#ffd9dc"
    readonly property color primary_fixed_dim: "#ffb2bb"
    readonly property color on_primary_fixed: "#3b0713"

    readonly property color secondary: "#e5bdc0"
    readonly property color on_secondary: "#43292c"
    readonly property color secondary_container: "#5c3f42"
    readonly property color on_secondary_container: "#ffd9dc"

    readonly property color tertiary: "#e9bf8f"
    readonly property color on_tertiary: "#442b07"
    readonly property color tertiary_container: "#5e411b"
    readonly property color on_tertiary_container: "#ffddb7"

    readonly property color outline: "#9f8c8d"
    readonly property color outline_variant: "#524344"

    readonly property color error: "#ffb4ab"
    readonly property color on_error: "#690005"
    readonly property color error_container: "#931d25"
    readonly property color on_error_container: "#ffdad6"

    readonly property color inverse_surface: "#f0dedf"
    readonly property color inverse_on_surface: "#382e2f"
}
