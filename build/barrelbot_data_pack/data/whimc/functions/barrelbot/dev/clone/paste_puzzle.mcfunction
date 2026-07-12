#> whimc:barrelbot/dev/clone/paste_puzzle
#   Pastes the puzzle

tag @s add whimc.clone_operator
scoreboard players operation $temp whimc.barrelbot.puzzle_id = @s whimc.barrelbot.puzzle_id

# If there's currently a puzzle entity here, replace it
execute align xyz as @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,dx=0,dy=0,dz=0] at @s run function whimc:barrelbot/manager/delete_puzzle

#Get center coordinates
execute store result score $paste_x whimc.dummy run data get entity @s Pos[0]
execute store result score $paste_y whimc.dummy run data get entity @s Pos[1]
execute store result score $paste_z whimc.dummy run data get entity @s Pos[2]

execute unless entity @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,predicate=whimc:barrelbot/match_id] run tellraw @s [{"text":"[Barrelbot] Clone failed: ","color":"red","bold":true},{"text":"Not bound to a puzzle. Link a puzzle with the edit wand or Puzzle > Link first.","color":"gray","bold":false}]
execute unless entity @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,predicate=whimc:barrelbot/match_id] run tag @s remove whimc.clone_operator
execute unless entity @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,predicate=whimc:barrelbot/match_id] run return 0

# Init clone counters
scoreboard players set $clone_index whimc.dummy 0
scoreboard players set $clone_total whimc.dummy 1
scoreboard players set $clone_successes whimc.dummy 0
scoreboard players set $clone_failures whimc.dummy 0
execute store result score $clone_start_time whimc.dummy run time query gametime

execute as @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,limit=1,predicate=whimc:barrelbot/match_id] store result storage whimc:macro puzzle_type int 1 run scoreboard players get @s whimc.barrelbot.puzzle_type_id
function whimc:barrelbot/manager/get_puzzle_name
tellraw @s [{"text":"[Barrelbot] Cloning puzzle: ","color":"aqua","bold":true},{"nbt":"puzzle_name","storage":"whimc:storage","color":"gold","bold":false}]

#Run all cloning stuff from the manager entity (but positioned at the player)
execute as @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,limit=1,predicate=whimc:barrelbot/match_id] run function whimc:barrelbot/clone/clone_as_manager

execute store result score $clone_end_time whimc.dummy run time query gametime
scoreboard players operation $clone_elapsed whimc.dummy = $clone_end_time whimc.dummy
scoreboard players operation $clone_elapsed whimc.dummy -= $clone_start_time whimc.dummy

execute if score $clone_successes whimc.dummy matches 1.. run tellraw @s [{"text":"[Barrelbot] Successfully cloned: ","color":"green","bold":true},{"nbt":"puzzle_name","storage":"whimc:storage","color":"gold","bold":false}]
execute if score $clone_successes whimc.dummy matches 1.. run tellraw @s [{"text":"  Created: ","color":"gray"},{"score":{"name":"$clone_successes","objective":"whimc.dummy"},"color":"yellow"},{"text":" copy","color":"gray"}]
execute if score $clone_failures whimc.dummy matches 1.. run tellraw @s [{"text":"[Barrelbot] Clone completed with errors.","color":"red","bold":true},{"text":" See warnings above.","color":"gray","bold":false}]
title @s actionbar [{"text":"Clone done: ","color":"aqua"},{"nbt":"puzzle_name","storage":"whimc:storage","color":"gold"}]

tag @s remove whimc.clone_operator
