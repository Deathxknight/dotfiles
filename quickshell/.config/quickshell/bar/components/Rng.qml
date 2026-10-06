pragma Singleton
import QtQuick
import Quickshell


Singleton {
    id: root
    function rand(i) {
        const x = Math.sin(i * 12.9898 + 78.233) * 43758.5453
        return x - Math.floor(x)
    }
    function rand2(i, j) { return rand(i * 131.7 + j * 7.13) }
    function range(i, lo, hi) { return lo + rand(i) * (hi - lo) }
    function range2(i, j, lo, hi) { return lo + rand2(i, j) * (hi - lo) }
}
