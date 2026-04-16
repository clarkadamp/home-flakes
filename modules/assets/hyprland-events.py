#!/usr/bin/env python
import asyncio
import subprocess
from collections.abc import Sequence
from typing import Literal, cast

import hyprland
from hyprland.info import fetch_clients

hypr = hyprland.Events()


def run_command(command: str) -> str:
    proc = subprocess.Popen(
        command.split(), stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True
    )
    try:
        outs, errs = proc.communicate(timeout=15)
    except subprocess.TimeoutExpired:
        proc.kill()
        outs, errs = proc.communicate()
    print(outs, errs)
    return outs


@hypr.on("connect")
async def on_connect():
    print("connected to the socket")


@hypr.on("fullscreen")
async def dim_keyboard_on_video(mode: Literal["0", "1"]):
    video_classes = {"google-chrome", "vlc"}
    match mode:
        case "1":
            for client in cast(Sequence[hyprland.Window], fetch_clients()):
                if client.fullscreen and client.class_name in video_classes:
                    _ = run_command(
                        "brightnessctl --device=tpacpi::kbd_backlight set 0",
                    )
        case "0":
            _ = run_command(
                "brightnessctl --device=tpacpi::kbd_backlight set 1",
            )


async def main():
    await hypr.async_connect()


print("starting")

asyncio.run(main())
