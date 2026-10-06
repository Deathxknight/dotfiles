#!/usr/bin/env python3
"""Prints "KEY_X pressed" / "KEY_X released" for every keyboard under /dev/input.
Used by KeyDisplay.qml. Needs python-evdev and membership of the `input` group.
Rescans every few seconds so hot-plugged keyboards are picked up."""
import asyncio
import sys

from evdev import InputDevice, ecodes, list_devices


def is_keyboard(dev):
    keys = dev.capabilities().get(ecodes.EV_KEY, [])
    return ecodes.KEY_A in keys and ecodes.KEY_LEFTMETA in keys


async def watch(dev):
    try:
        async for ev in dev.async_read_loop():
            if ev.type != ecodes.EV_KEY or ev.value not in (0, 1):
                continue  # ignore auto-repeat (2)
            name = ecodes.KEY.get(ev.code)
            if isinstance(name, list):
                name = name[0]
            if name:
                print(f"{name} {'pressed' if ev.value else 'released'}", flush=True)
    except OSError:
        pass  # device unplugged
    finally:
        dev.close()


async def main():
    tasks = {}
    while True:
        for path in list_devices():
            if path in tasks and not tasks[path].done():
                continue
            try:
                dev = InputDevice(path)
            except OSError as e:
                print(f"keywatch: cannot open {path}: {e}", file=sys.stderr, flush=True)
                continue
            if is_keyboard(dev):
                tasks[path] = asyncio.create_task(watch(dev))
            else:
                dev.close()
        await asyncio.sleep(3)


try:
    asyncio.run(main())
except KeyboardInterrupt:
    pass
