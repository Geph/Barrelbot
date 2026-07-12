#> whimc:barrelbot/dev/link_puzzle
#   Link yourself to the ID of the nearest puzzle

execute unless entity @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,limit=1,sort=nearest] run tellraw @s [{"text":"[Barrelbot] Link failed: ","color":"red","bold":true},{"text":"No puzzle manager nearby.","color":"gray","bold":false}]
execute unless entity @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,limit=1,sort=nearest] run return 0

scoreboard players operation @s whimc.barrelbot.puzzle_id = @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,limit=1,sort=nearest] whimc.barrelbot.puzzle_id
execute as @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,limit=1,sort=nearest] store result storage whimc:macro puzzle_type int 1 run scoreboard players get @s whimc.barrelbot.puzzle_type_id
function whimc:barrelbot/manager/get_puzzle_name
tellraw @s [{"text":"[Barrelbot] Successfully linked to: ","color":"green","bold":true},{"nbt":"puzzle_name","storage":"whimc:storage","color":"gold","bold":false}]
tellraw @s [{"text":"  Puzzle ID: ","color":"gray"},{"score":{"name":"@s","objective":"whimc.barrelbot.puzzle_id"},"color":"yellow"},{"text":"  Type ID: ","color":"gray"},{"nbt":"puzzle_type","storage":"whimc:macro","color":"yellow"}]
