# Effects

Drop .qml files here, then:

1. Add one entry in Effects.qml's `fxModel`:
       { file: "Aurora.qml", id: "aurora", def: false },
2. Add one entry in SettingsContent.qml's `fxList`:
       { id: "aurora", name: "Aurora" },

The `id` must match the effect file's `fxId`.

Each effect must expose:
    readonly property string fxId
    property bool fxDefault       (optional, default false)
    property bool enabled
    property real intensity
    property real speed
    property real barRadius

Start from _Template.qml.
Colours: Colors.primary / secondary / tertiary / on_surface.
Random: Rng.rand(i), Rng.range(i, lo, hi).
