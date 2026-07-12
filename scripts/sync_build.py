#!/usr/bin/env python3
"""Sync src/ into build/ packs for Minecraft 1.20.4 without a full beet/kmc rebuild.

Use this when iterating on .mcfunction / texture changes. Full Bolt UI regeneration
still needs the private kmc packages via `beet build`.
"""
from __future__ import annotations

import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
BUILD_DP = ROOT / "build" / "barrelbot_data_pack"
BUILD_RP = ROOT / "build" / "barrelbot_resource_pack"
CACHE = ROOT / ".kmc" / "cmd_cache.json"


def copy_tree(src: Path, dst: Path, skip_parts=()) -> int:
    n = 0
    for path in src.rglob("*"):
        if not path.is_file():
            continue
        if any(p in path.parts for p in skip_parts):
            continue
        rel = path.relative_to(src)
        out = dst / rel
        out.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, out)
        n += 1
    return n


def pane_cmd(model: str) -> int:
    cache = json.loads(CACHE.read_text())
    pane = cache["white_stained_glass_pane"]
    for cmd, name in pane.items():
        if name == model:
            return int(cmd)
    raise KeyError(model)


def apply_wand_page_overlays() -> None:
    """Keep hand-maintained wand page entries that Bolt would normally regenerate."""
    pages = (
        BUILD_DP
        / "data/whimc/functions/barrelbot/editor/edit_wand/edit_mode/pages"
    )
    glp = pane_cmd("whimc:barrelbot/ui/get_linked_puzzle")
    inf = pane_cmd("whimc:barrelbot/ui/instructions/infinite_loop")
    end = pane_cmd("whimc:barrelbot/ui/instructions/end_code_block")
    close = pane_cmd("whimc:barrelbot/ui/close")

    (pages / "instructor.mcfunction").write_text(
        f"""data modify storage whimc:storage Page set value {{Buttons: [], Text: []}}
data modify storage whimc:storage Page.key set value "instructor"
data modify storage whimc:storage Page.Text append value {{data: {{transformation: {{translation: [0.0f, 0.5f, 0.1f], scale: [1.0f, 1.0f, 1.0f]}}}}, text_provider: '{{"text":"Instructor","color":"aqua"}}'}}
data modify storage whimc:storage Page.Buttons append value {{item: {{id: "minecraft:white_stained_glass_pane", tag: {{CustomModelData: {glp}}}}}, x_min: -150, x_max: 150, y_min: -400, y_max: -100, command: "function whimc:barrelbot/editor/edit_wand/edit_mode/pages/get_linked_puzzle", hover_text: "Get Linked Puzzle"}}
data modify storage whimc:storage Page.Buttons append value {{item: {{id: "minecraft:white_stained_glass_pane", tag: {{CustomModelData: {close}}}}}, x_min: -125, x_max: 125, y_min: -775, y_max: -525, command: "function whimc:barrelbot/editor/edit_wand/edit_mode/pages/close", hover_text: "Exit Menu"}}
"""
    )

    (pages / "register_pages.mcfunction").write_text(
        """data modify storage whimc:const WandPages set value []
function whimc:barrelbot/editor/edit_wand/edit_mode/pages/barrelbot
data modify storage whimc:const WandPages append from storage whimc:storage Page
function whimc:barrelbot/editor/edit_wand/edit_mode/pages/puzzle
data modify storage whimc:const WandPages append from storage whimc:storage Page
function whimc:barrelbot/editor/edit_wand/edit_mode/pages/function
data modify storage whimc:const WandPages append from storage whimc:storage Page
function whimc:barrelbot/editor/edit_wand/edit_mode/pages/instructor
data modify storage whimc:const WandPages append from storage whimc:storage Page
function whimc:barrelbot/editor/edit_wand/edit_mode/pages/general
data modify storage whimc:const WandPages append from storage whimc:storage Page
function whimc:barrelbot/editor/edit_wand/edit_mode/pages/instructions
data modify storage whimc:const WandPages append from storage whimc:storage Page
function whimc:barrelbot/editor/edit_wand/edit_mode/pages/blocks
data modify storage whimc:const WandPages append from storage whimc:storage Page
function whimc:barrelbot/editor/edit_wand/edit_mode/pages/success_conditions_0
data modify storage whimc:const WandPages append from storage whimc:storage Page
function whimc:barrelbot/editor/edit_wand/edit_mode/pages/bot_success_conditions_0
data modify storage whimc:const WandPages append from storage whimc:storage Page
"""
    )

    inst_path = pages / "instructions.mcfunction"
    lines = [
        ln
        for ln in inst_path.read_text().splitlines()
        if "give_infinite" not in ln and "end_code_block/give" not in ln
    ]
    text = "\n".join(lines).rstrip() + "\n"
    text += f"""data modify storage whimc:storage Page.Buttons append value {{item: {{id: "minecraft:white_stained_glass_pane", tag: {{CustomModelData: {inf}}}}}, x_min: 500, x_max: 700, y_min: -300, y_max: -100, command: "function whimc:barrelbot/instructions/loop/give_infinite", hover_text: "Infinite Loop"}}
data modify storage whimc:storage Page.Buttons append value {{item: {{id: "minecraft:white_stained_glass_pane", tag: {{CustomModelData: {end}}}}}, x_min: 299, x_max: 499, y_min: -300, y_max: -100, command: "function whimc:barrelbot/instructions/end_code_block/give", hover_text: "End Code Block"}}
"""
    inst_path.write_text(text)


def main() -> None:
    n1 = copy_tree(SRC / "data" / "whimc", BUILD_DP / "data" / "whimc", skip_parts=("modules",))
    n2 = copy_tree(SRC / "assets" / "whimc", BUILD_RP / "assets" / "whimc")
    (BUILD_DP / "pack.mcmeta").write_text(
        json.dumps(
            {
                "pack": {
                    "pack_format": 26,
                    "description": "WHIMC Barrelbot Pack\nAuthor: Kobe Duda",
                }
            },
            indent=2,
        )
        + "\n"
    )
    (BUILD_RP / "pack.mcmeta").write_text(
        json.dumps(
            {
                "pack": {
                    "pack_format": 22,
                    "description": "WHIMC Barrelbot Pack\nAuthor: Kobe Duda",
                }
            },
            indent=2,
        )
        + "\n"
    )
    apply_wand_page_overlays()
    print(f"Synced {n1} datapack files, {n2} resource pack files")
    print("Applied wand page overlays (instructor / infinite loop / end block)")
    print("pack_format datapack=26 resource=22 (1.20.4)")


if __name__ == "__main__":
    main()
