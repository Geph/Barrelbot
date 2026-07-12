#> whimc:barrelbot/editor/edit_wand/report_linked_puzzle
#   Executed as the instructor entity. Prints linked puzzle diagnostics.

execute store result score $linked_type whimc.dummy run scoreboard players get @s whimc.barrelbot.puzzle_type_id
execute store result score $linked_id whimc.dummy run scoreboard players get @s whimc.barrelbot.puzzle_id

execute unless score $linked_type whimc.dummy matches 1.. run tellraw @a[tag=whimc.in_edit_menu] [{"text":"[Barrelbot] ","color":"red","bold":true},{"text":"Instructor is not linked to a puzzle.","color":"gray","bold":false}]
execute unless score $linked_type whimc.dummy matches 1.. run tellraw @a[tag=whimc.in_edit_menu] [{"text":"  Tip: Stand near a puzzle button and use Puzzle > Link, or resize the puzzle so this instructor is inside the boundary.","color":"dark_gray"}]
execute unless score $linked_type whimc.dummy matches 1.. run return 0

execute store result storage whimc:macro puzzle_type int 1 run scoreboard players get $linked_type whimc.dummy
function whimc:barrelbot/manager/get_puzzle_name

tellraw @a[tag=whimc.in_edit_menu] [{"text":"[Barrelbot] Linked Puzzle","color":"aqua","bold":true}]
tellraw @a[tag=whimc.in_edit_menu] [{"text":"  Name: ","color":"gray"},{"nbt":"puzzle_name","storage":"whimc:storage","color":"gold"}]
tellraw @a[tag=whimc.in_edit_menu] [{"text":"  Puzzle Type ID: ","color":"gray"},{"score":{"name":"$linked_type","objective":"whimc.dummy"},"color":"yellow"}]
tellraw @a[tag=whimc.in_edit_menu] [{"text":"  Puzzle ID: ","color":"gray"},{"score":{"name":"$linked_id","objective":"whimc.dummy"},"color":"yellow"}]

# Also report whether a matching manager currently exists
scoreboard players operation $temp whimc.barrelbot.puzzle_type_id = $linked_type whimc.dummy
execute store result score $manager_found whimc.dummy if entity @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,predicate=whimc:barrelbot/match_puzzle_type_id,limit=1]
execute if score $manager_found whimc.dummy matches 1 run tellraw @a[tag=whimc.in_edit_menu] [{"text":"  Manager: ","color":"gray"},{"text":"found","color":"green"}]
execute if score $manager_found whimc.dummy matches 0 run tellraw @a[tag=whimc.in_edit_menu] [{"text":"  Manager: ","color":"gray"},{"text":"MISSING (puzzle manager not loaded or deleted)","color":"red"}]
