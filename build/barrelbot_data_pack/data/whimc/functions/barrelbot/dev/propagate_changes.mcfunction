#> whimc:barrelbot/dev/propagate_changes
#   Propagate any changes to the puzzle to all clones

tag @s add whimc.clone_operator
scoreboard players operation $temp whimc.barrelbot.puzzle_id = @s whimc.barrelbot.puzzle_id

execute unless entity @e[type=text_display,limit=1,predicate=whimc:barrelbot/match_id,tag=whimc.barrelbot.puzzle_manager] run tellraw @s [{"text":"[Barrelbot] Propagate failed: ","color":"red","bold":true},{"text":"Not linked to a puzzle manager.","color":"gray","bold":false}]
execute unless entity @e[type=text_display,limit=1,predicate=whimc:barrelbot/match_id,tag=whimc.barrelbot.puzzle_manager] run tag @s remove whimc.clone_operator
execute unless entity @e[type=text_display,limit=1,predicate=whimc:barrelbot/match_id,tag=whimc.barrelbot.puzzle_manager] run return 0

execute as @e[type=text_display,limit=1,predicate=whimc:barrelbot/match_id,tag=whimc.barrelbot.puzzle_manager] store result storage whimc:macro puzzle_type int 1 run scoreboard players get @s whimc.barrelbot.puzzle_type_id
function whimc:barrelbot/manager/get_puzzle_name

scoreboard players set $propagate_count whimc.dummy 0
execute as @e[type=text_display,limit=1,predicate=whimc:barrelbot/match_id,tag=whimc.barrelbot.puzzle_manager] at @s run function whimc:barrelbot/clone/propagate/propagate_changes

tellraw @s [{"text":"[Barrelbot] Propagated changes for: ","color":"green","bold":true},{"nbt":"puzzle_name","storage":"whimc:storage","color":"gold","bold":false}]
tellraw @s [{"text":"  Updated clones: ","color":"gray"},{"score":{"name":"$propagate_count","objective":"whimc.dummy"},"color":"yellow"}]
execute if score $propagate_count whimc.dummy matches 0 run tellraw @s [{"text":"  Warning: ","color":"gold"},{"text":"No other clones with this puzzle_type_id were found (they may be unloaded).","color":"gray"}]
title @s actionbar [{"text":"Propagate complete","color":"green"}]
tag @s remove whimc.clone_operator
