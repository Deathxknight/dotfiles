#!/usr/bin/env bash
export QML_IMPORT_PATH="$HOME/.local/lib/qml${QML_IMPORT_PATH:+:$QML_IMPORT_PATH}"
exec quickshell -c bar "$@"
