#!/usr/bin/env bash
# recolors bibata to match matugen primary_container
#
# exact color by default. a new color takes ~15s to build, then it is cached
#
# if a build is running we wait instead of skipping, so the newest wallpaper wins
#
# Modes:
#   (none)      Recolor to current wallpaper.
#   --warm      Prebuild all palette buckets (only if palette enabled).
#   --palette   Print palette buckets.
#   --status    Show cache + install state.
#   --clear     Wipe cache and installed marker.
#   --help      This message.

set -euo pipefail

# config

SRC="${CURSOR_SRC:-$HOME/.config/matugen/cursor-src}"
CACHE_DIR="${CURSOR_CACHE:-$HOME/.cache/matugen-cursor-cache}"
COLORS_CSS="${COLORS_CSS:-$HOME/.config/mozilla/firefox/mnvwbvy5.default-release/chrome/colors.css}"
THEME_NAME="Bibata-Modern-Amber"
CURSOR_SIZE=24

INSTALLED_MARKER="$HOME/.cache/matugen-cursor-installed"
LOCKDIR="$HOME/.cache/matugen-cursor.lockdir"
LOCK_PIDFILE="$LOCKDIR/pid"
LOG_FILE="${CURSOR_LOG:-/tmp/cursor-recolor.log}"

# 0 = exact color
HUE_BUCKETS="${HUE_BUCKETS:-0}"
SAT_BUCKETS="${SAT_BUCKETS:-0}"
VAL_BUCKETS="${VAL_BUCKETS:-0}"

VAL_LO="${VAL_LO:-0.40}"
VAL_HI="${VAL_HI:-0.90}"
SAT_LO="${SAT_LO:-0.15}"
SAT_HI="${SAT_HI:-0.85}"

X11="${X11:-1}"
WARM_BACKGROUND="${WARM_BACKGROUND:-0}"

# how long to wait on another build before stealing the lock (a build is ~15s)
LOCK_WAIT_MAX="${LOCK_WAIT_MAX:-45}"

# logging

log()  { printf '[recolor-cursor] %s\n' "$*"; }
die()  { log "$*" >&2; exit 1; }
debug(){ [[ "${DEBUG:-0}" == "1" ]] && printf '[recolor-cursor:debug] %s\n' "$*" >&2 || true; }

# session env

recover_hypr_env() {
    [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]] && return 0
    local d
    for d in "${XDG_RUNTIME_DIR:-/run/user/$UID}/hypr"/*/; do
        if [[ -S "${d}.socket2.sock" || -S "${d}.socket.sock" ]]; then
            export HYPRLAND_INSTANCE_SIGNATURE=$(basename "$d")
            return 0
        fi
    done
}

recover_dbus_env() {
    if [[ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
        local bus="/run/user/$UID/bus"
        [[ -S "$bus" ]] && export DBUS_SESSION_BUS_ADDRESS="unix:path=$bus"
    fi
}

# lock

# returns 0 if we got the lock, prints stale if we stole it
try_acquire_lock() {
    if mkdir "$LOCKDIR" 2>/dev/null; then
        echo $$ > "$LOCK_PIDFILE"
        return 0
    fi

    # lock exists, is the holder still alive?
    local holder_pid=""
    [[ -r "$LOCK_PIDFILE" ]] && holder_pid=$(cat "$LOCK_PIDFILE" 2>/dev/null || echo "")

    if [[ -n "$holder_pid" ]] && ! kill -0 "$holder_pid" 2>/dev/null; then
        debug "stale lock: pid $holder_pid is dead"
        rm -rf "$LOCKDIR"
        mkdir "$LOCKDIR" 2>/dev/null && { echo $$ > "$LOCK_PIDFILE"; return 0; }
    fi

    # holder is alive, caller decides whether to wait
    return 1
}

acquire_lock_wait() {
    local waited=0
    while ! try_acquire_lock; do
        if (( waited >= LOCK_WAIT_MAX )); then
            log "lock held for >${LOCK_WAIT_MAX}s — stealing"
            rm -rf "$LOCKDIR"
            mkdir "$LOCKDIR" 2>/dev/null && { echo $$ > "$LOCK_PIDFILE"; break; }
            continue
        fi
        sleep 1
        waited=$((waited + 1))
    done
    trap 'rm -rf "$LOCKDIR" 2>/dev/null || true' EXIT
}

# quantization

_snap_py='
import sys, colorsys
def snap(x, n, lo=0.0, hi=1.0):
    if n <= 0: return x
    x = max(lo, min(hi, x)); span = hi - lo
    return lo + (round((x - lo) / span * n - 0.5) / n + 0.5 / n) * span
mode = sys.argv[1]
hb, sb, vb = int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])
slo, shi = float(sys.argv[5]), float(sys.argv[6])
vlo, vhi = float(sys.argv[7]), float(sys.argv[8])
if mode == "hex":
    raw = sys.argv[9].lstrip("#")
    r, g, b = (int(raw[i:i+2], 16)/255 for i in (0, 2, 4))
    h, s, v = colorsys.rgb_to_hsv(r, g, b)
elif mode == "idx":
    hi, si, vi = int(sys.argv[9]), int(sys.argv[10]), int(sys.argv[11])
    h = (hi + 0.5) / hb if hb > 0 else 0.0
    s = (slo + (si + 0.5) / sb * (shi - slo)) if sb > 0 else (slo + shi) / 2
    v = (vlo + (vi + 0.5) / vb * (vhi - vlo)) if vb > 0 else (vlo + vhi) / 2
else:
    raise SystemExit("bad mode")
h = snap(h, hb) % 1.0
s = max(0.0, min(1.0, snap(s, sb, slo, shi)))
v = max(0.0, min(1.0, snap(v, vb, vlo, vhi)))
r, g, b = colorsys.hsv_to_rgb(h, s, v)
print("#%02X%02X%02X" % (round(r*255), round(g*255), round(b*255)))
'

quantize_hex() {
    python3 -c "$_snap_py" hex \
        "$HUE_BUCKETS" "$SAT_BUCKETS" "$VAL_BUCKETS" \
        "$SAT_LO" "$SAT_HI" "$VAL_LO" "$VAL_HI" "$1"
}

palette_seed() {
    python3 -c "$_snap_py" idx \
        "$HUE_BUCKETS" "$SAT_BUCKETS" "$VAL_BUCKETS" \
        "$SAT_LO" "$SAT_HI" "$VAL_LO" "$VAL_HI" "$1" "$2" "$3"
}

palette_enabled() { (( HUE_BUCKETS > 0 && SAT_BUCKETS > 0 && VAL_BUCKETS > 0 )); }
palette_total()   { if palette_enabled; then echo $((HUE_BUCKETS*SAT_BUCKETS*VAL_BUCKETS)); else echo 0; fi; }

# install

apply_cursor() {
    local color="$1"
    recover_dbus_env

    # hyprland needs a moment to see new files
    local tries=0 rc=1
    while (( tries < 3 )); do
        if hyprctl setcursor "$THEME_NAME" "$CURSOR_SIZE" >/dev/null 2>&1; then
            rc=0; break
        fi
        sleep 0.3
        tries=$((tries + 1))
    done

    if ! gsettings set org.gnome.desktop.interface cursor-theme "$THEME_NAME" 2>/dev/null; then
        log "WARNING: gsettings failed (no D-Bus session?)"
    fi
    gsettings set org.gnome.desktop.interface cursor-size "$CURSOR_SIZE" 2>/dev/null || true

    {
        echo "--- $(date -Iseconds) ---"
        echo "color=$color"
        echo "DBUS=[${DBUS_SESSION_BUS_ADDRESS:-UNSET}]"
        echo "HYPRLAND_INSTANCE_SIGNATURE=[${HYPRLAND_INSTANCE_SIGNATURE:-UNSET}]"
        echo "setcursor_retries=$tries rc=$rc"
    } >> "$LOG_FILE" 2>&1 || true
}

theme_is_complete() {
    local dest="$HOME/.local/share/icons/$THEME_NAME"
    [[ -d "$dest/hyprcursors" ]] || return 1
    [[ -n "$(ls -A "$dest/hyprcursors" 2>/dev/null)" ]] || return 1
    if [[ "$X11" == "1" ]]; then
        [[ -d "$dest/cursors" ]] || return 1
        [[ -n "$(ls -A "$dest/cursors" 2>/dev/null)" ]] || return 1
    fi
    return 0
}

install_theme() {
    local built="$1"
    local dest="$HOME/.local/share/icons/$THEME_NAME"
    rm -rf "$dest"
    cp -a --reflink=auto "$built" "$dest" 2>/dev/null \
        || cp -al "$built" "$dest" 2>/dev/null \
        || cp -a "$built" "$dest"

    if [[ "$X11" == "1" ]] && [[ ! -d "$dest/cursors" ]]; then
        die "install finished but $dest/cursors missing"
    fi
    if [[ ! -d "$dest/hyprcursors" ]]; then
        log "WARNING: $dest/hyprcursors missing"
    fi
}

# build

patch_render_json() {
    local color="$1"
    cd "$SRC"
    [[ -f config/render.json.bak ]] || cp config/render.json config/render.json.bak
    cp config/render.json.bak config/render.json

    python3 - "$color" "$THEME_NAME" <<'PY'
import json, pathlib, sys
color, variant = sys.argv[1], sys.argv[2]
p = pathlib.Path("config/render.json")
data = json.loads(p.read_text())
RULES = {"#00FF00": color, "#0000FF": "#FFFFFF", "#FF0000": "#1E1E1E"}
entry = data.get(variant)
if entry:
    for c in entry.get("colors", []):
        m = c.get("match", "").upper()
        if m in RULES:
            c["replace"] = RULES[m]
p.write_text(json.dumps(data, indent=2))
PY
}

build_color() {
    local color="$1"
    local slug="${color#\#}"
    local out="$CACHE_DIR/$slug"
    local scratch="./out-$$"

    log "building $color"
    mkdir -p "$CACHE_DIR"
    patch_render_json "$color"
    cd "$SRC"

    rm -rf "$scratch"
    local flags=(--theme "$THEME_NAME" --hypr --out-dir "$scratch" --log-level error)
    [[ "$X11" == "1" ]] && flags+=(--x11)

    if ! ./src/cursor_utils.py "${flags[@]}"; then
        log "cursor_utils.py failed for $color"
        rm -rf "$SRC/${scratch#./}"
        return 1
    fi

    local built="$SRC/${scratch#./}/$THEME_NAME"
    if [[ ! -d "$built" ]]; then
        log "build produced no output at $built"
        rm -rf "$SRC/${scratch#./}"
        return 1
    fi

    rm -rf "$out"
    mkdir -p "$out"
    mv "$built" "$out/$THEME_NAME"
    rm -rf "$SRC/${scratch#./}"
    return 0
}

# modes

mode_warm() {
    if ! palette_enabled; then
        die "palette disabled (HUE/SAT/VAL buckets all 0). Set them >0 to use --warm."
    fi
    recover_hypr_env
    acquire_lock_wait
    [[ -d "$SRC" ]] || die "cursor source not found: $SRC"
    local total; total=$(palette_total)
    log "warming palette: ${HUE_BUCKETS}h × ${SAT_BUCKETS}s × ${VAL_BUCKETS}v = $total buckets"

    local built=0 skipped=0 failed=0
    local h s v seed q slug
    for (( h=0; h<HUE_BUCKETS; h++ )); do
        for (( s=0; s<SAT_BUCKETS; s++ )); do
            for (( v=0; v<VAL_BUCKETS; v++ )); do
                seed=$(palette_seed "$h" "$s" "$v")
                q=$(quantize_hex "$seed")
                slug="${q#\#}"
                [[ -d "$CACHE_DIR/$slug/$THEME_NAME" ]] && { skipped=$((skipped+1)); continue; }
                if build_color "$q"; then built=$((built+1)); else failed=$((failed+1)); fi
            done
        done
    done
    log "warm complete: built=$built skipped=$skipped failed=$failed"
}

mode_palette() {
    if ! palette_enabled; then
        echo "palette disabled (exact color). Set HUE_BUCKETS/SAT_BUCKETS/VAL_BUCKETS >0 to enable."
        return 0
    fi
    local h s v seed q
    for (( h=0; h<HUE_BUCKETS; h++ )); do
        for (( s=0; s<SAT_BUCKETS; s++ )); do
            for (( v=0; v<VAL_BUCKETS; v++ )); do
                seed=$(palette_seed "$h" "$s" "$v")
                q=$(quantize_hex "$seed")
                printf '%2d/%d/%d  seed=%s  bucket=%s\n' "$h" "$s" "$v" "$seed" "$q"
            done
        done
    done
}

mode_status() {
    echo "palette mode: $(palette_enabled && echo "on ($(palette_total) buckets)" || echo 'off (exact color)')"
    echo "cache dir:    $CACHE_DIR"
    echo "marker:       $(cat "$INSTALLED_MARKER" 2>/dev/null || echo '(none)')"
    echo "theme on disk: $([[ -d "$HOME/.local/share/icons/$THEME_NAME" ]] && echo yes || echo no)"
    echo "theme complete: $(theme_is_complete && echo yes || echo no)"
    echo
    echo "cached buckets:"
    if [[ -d "$CACHE_DIR" ]]; then
        local n=0
        while IFS= read -r d; do
            [[ -d "$d/$THEME_NAME" ]] || continue
            printf '  #%s\n' "$(basename "$d")"
            n=$((n+1))
        done < <(find "$CACHE_DIR" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sort)
        (( n == 0 )) && echo "  (empty)"
    else
        echo "  (empty)"
    fi
}

mode_clear() {
    rm -rf "$CACHE_DIR" "$INSTALLED_MARKER" "$LOCKDIR"
    log "cache cleared"
}

read_primary_color() {
    [[ -f "$COLORS_CSS" ]] || return 1
    grep -oP '^\s*--primary_container:\s*\K#[a-fA-F0-9]{6}' "$COLORS_CSS" | head -1
}

mode_recolor() {
    recover_hypr_env
    recover_dbus_env

    [[ -d "$SRC" ]] || die "cursor source not found: $SRC"

    # wait for a running build, then re-read colors.css in case the wallpaper changed
    local attempts=0
    while true; do
        if try_acquire_lock; then
            trap 'rm -rf "$LOCKDIR" 2>/dev/null || true' EXIT
            break
        fi
        if (( attempts >= 3 )); then
            log "lock contended too long, forcing"
            rm -rf "$LOCKDIR"
            mkdir "$LOCKDIR" 2>/dev/null && { echo $$ > "$LOCK_PIDFILE"; }
            trap 'rm -rf "$LOCKDIR" 2>/dev/null || true' EXIT
            break
        fi
        debug "waiting for concurrent build"
        sleep 1
        attempts=$((attempts+1))
    done

    local raw; raw=$(read_primary_color) || die "could not read primary_container"
    [[ -n "$raw" ]] || die "primary_container is empty"

    local primary; primary=$(quantize_hex "$raw")
    if [[ "$primary" == "$raw" ]]; then
        log "raw=$raw (exact)"
    else
        log "raw=$raw bucket=$primary"
    fi

    local installed; installed=$(cat "$INSTALLED_MARKER" 2>/dev/null || echo "")

    # bail early if the marker matches and the theme is complete
    if [[ "$primary" == "$installed" ]] && theme_is_complete; then
        log "already on $primary, nothing to do"
        exit 0
    fi

    local slug="${primary#\#}"
    local cached="$CACHE_DIR/$slug"

    if [[ -d "$cached/$THEME_NAME" ]]; then
        log "cache hit"
        install_theme "$cached/$THEME_NAME"
        apply_cursor "$primary"
        echo "$primary" > "$INSTALLED_MARKER"
        log "done (cached)"
        exit 0
    fi

    build_color "$primary" || die "build failed"
    install_theme "$cached/$THEME_NAME"
    apply_cursor "$primary"
    echo "$primary" > "$INSTALLED_MARKER"
    log "done (built)"

    if [[ "$WARM_BACKGROUND" == "1" ]] && palette_enabled; then
        if command -v systemd-run >/dev/null 2>&1; then
            systemd-run --user --scope --collect -q --unit="cursor-warm-$$" \
                "$0" --warm >/dev/null 2>&1 || true
        else
            ( "$0" --warm >/dev/null 2>&1 & ) || true
        fi
    fi
}

# entry

case "${1:-}" in
    --warm)     mode_warm ;;
    --palette)  mode_palette ;;
    --status)   mode_status ;;
    --clear)    mode_clear ;;
    --help|-h)
        sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'
        echo
        echo "Current settings:"
        echo "  HUE_BUCKETS=$HUE_BUCKETS SAT_BUCKETS=$SAT_BUCKETS VAL_BUCKETS=$VAL_BUCKETS"
        echo "  X11=$X11  WARM_BACKGROUND=$WARM_BACKGROUND"
        echo "  LOCK_WAIT_MAX=$LOCK_WAIT_MAX"
        ;;
    "")         mode_recolor ;;
    *)          die "unknown mode: $1 (try --help)" ;;
esac
