#> whimc:barrelbot/dev/clone/paste_cascade
#   Pastes a cascade clone

tag @s add whimc.clone_operator
scoreboard players operation $temp whimc.barrelbot.puzzle_id = @s whimc.barrelbot.puzzle_id

execute unless entity @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,predicate=whimc:barrelbot/match_id] run tellraw @s [{"text":"[Barrelbot] Cascade clone failed: ","color":"red","bold":true},{"text":"Not bound to a puzzle. Link a puzzle first.","color":"gray","bold":false}]
execute unless entity @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,predicate=whimc:barrelbot/match_id] run tag @s remove whimc.clone_operator
execute unless entity @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,predicate=whimc:barrelbot/match_id] run return 0

#Clean up any invalid inputs
execute if score @s whimc.barrelbot.cascade.x_spacing matches ..-1 run tellraw @s [{"text":"[Barrelbot] Note: ","color":"gold"},{"text":"Negative X spacing is invalid; X count forced to 0.","color":"gray"}]
execute if score @s whimc.barrelbot.cascade.z_spacing matches ..-1 run tellraw @s [{"text":"[Barrelbot] Note: ","color":"gold"},{"text":"Negative Z spacing is invalid; Z count forced to 0.","color":"gray"}]
execute if score @s whimc.barrelbot.cascade.x_spacing matches ..-1 run scoreboard players set @s whimc.barrelbot.cascade.x 0
execute if score @s whimc.barrelbot.cascade.z_spacing matches ..-1 run scoreboard players set @s whimc.barrelbot.cascade.z 0

#Transfer to fakeplayers
scoreboard players operation $temp whimc.barrelbot.cascade.x = @s whimc.barrelbot.cascade.x
scoreboard players operation $temp whimc.barrelbot.cascade.z = @s whimc.barrelbot.cascade.z
scoreboard players operation $temp whimc.barrelbot.cascade.x_spacing = @s whimc.barrelbot.cascade.x_spacing
scoreboard players operation $temp whimc.barrelbot.cascade.z_spacing = @s whimc.barrelbot.cascade.z_spacing

# Compute total copies (absolute counts)
scoreboard players operation $abs_x whimc.dummy = $temp whimc.barrelbot.cascade.x
scoreboard players operation $abs_z whimc.dummy = $temp whimc.barrelbot.cascade.z
execute if score $abs_x whimc.dummy matches ..-1 run scoreboard players operation $abs_x whimc.dummy *= #-1 whimc.const
execute if score $abs_z whimc.dummy matches ..-1 run scoreboard players operation $abs_z whimc.dummy *= #-1 whimc.const
scoreboard players operation $clone_total whimc.dummy = $abs_x whimc.dummy
scoreboard players operation $clone_total whimc.dummy *= $abs_z whimc.dummy
# Cascade layout clones neighbors, not the origin; if either axis is 0, treat as single-axis fan
execute if score $abs_x whimc.dummy matches 0 if score $abs_z whimc.dummy matches 1.. run scoreboard players operation $clone_total whimc.dummy = $abs_z whimc.dummy
execute if score $abs_z whimc.dummy matches 0 if score $abs_x whimc.dummy matches 1.. run scoreboard players operation $clone_total whimc.dummy = $abs_x whimc.dummy
# Actual cascade creates (x*z - 1) additional copies when both > 0 because origin is skipped; iterate wrappers already skip first cell
execute if score $abs_x whimc.dummy matches 1.. if score $abs_z whimc.dummy matches 1.. run scoreboard players remove $clone_total whimc.dummy 1

execute if score $clone_total whimc.dummy matches ..0 run tellraw @s [{"text":"[Barrelbot] Cascade clone failed: ","color":"red","bold":true},{"text":"X/Z counts produce zero copies. Set cascade dimensions first.","color":"gray","bold":false}]
execute if score $clone_total whimc.dummy matches ..0 run tag @s remove whimc.clone_operator
execute if score $clone_total whimc.dummy matches ..0 run return 0

#Get dimension data
execute as @e[type=text_display,limit=1,predicate=whimc:barrelbot/match_id,tag=whimc.barrelbot.puzzle_manager] on passengers run data modify storage whimc:storage bounding_box set from entity @s data.bounding_box
execute store result score $jump_x whimc.dummy run data get storage whimc:storage bounding_box.max_x
execute store result score $min_x whimc.dummy run data get storage whimc:storage bounding_box.min_x
scoreboard players operation $jump_x whimc.dummy -= $min_x whimc.dummy
execute if score $jump_x whimc.dummy matches ..-1 run scoreboard players operation $jump_x whimc.dummy *= #-1 whimc.const
scoreboard players add $jump_x whimc.dummy 1
scoreboard players operation $jump_x whimc.dummy += $temp whimc.barrelbot.cascade.x_spacing

execute store result score $jump_z whimc.dummy run data get storage whimc:storage bounding_box.max_z
execute store result score $min_z whimc.dummy run data get storage whimc:storage bounding_box.min_z
scoreboard players operation $jump_z whimc.dummy -= $min_z whimc.dummy
execute if score $jump_z whimc.dummy matches ..-1 run scoreboard players operation $jump_z whimc.dummy *= #-1 whimc.const
scoreboard players add $jump_z whimc.dummy 1
scoreboard players operation $jump_z whimc.dummy += $temp whimc.barrelbot.cascade.z_spacing

#Get sign
execute if score $temp whimc.barrelbot.cascade.x matches ..-1 run scoreboard players operation $jump_x whimc.dummy *= #-1 whimc.const
execute if score $temp whimc.barrelbot.cascade.z matches ..-1 run scoreboard players operation $jump_z whimc.dummy *= #-1 whimc.const
execute if score $temp whimc.barrelbot.cascade.x matches ..-1 run scoreboard players operation $temp whimc.barrelbot.cascade.x *= #-1 whimc.const
execute if score $temp whimc.barrelbot.cascade.z matches ..-1 run scoreboard players operation $temp whimc.barrelbot.cascade.z *= #-1 whimc.const

execute store result storage whimc:macro jump.x int 1 run scoreboard players get $jump_x whimc.dummy
execute store result storage whimc:macro jump.z int 1 run scoreboard players get $jump_z whimc.dummy

scoreboard players set $clone_index whimc.dummy 0
scoreboard players set $clone_successes whimc.dummy 0
scoreboard players set $clone_failures whimc.dummy 0
execute store result score $clone_start_time whimc.dummy run time query gametime

execute as @e[type=text_display,limit=1,predicate=whimc:barrelbot/match_id,tag=whimc.barrelbot.puzzle_manager] store result storage whimc:macro puzzle_type int 1 run scoreboard players get @s whimc.barrelbot.puzzle_type_id
function whimc:barrelbot/manager/get_puzzle_name
tellraw @s [{"text":"[Barrelbot] Cascade cloning: ","color":"aqua","bold":true},{"nbt":"puzzle_name","storage":"whimc:storage","color":"gold","bold":false}]
tellraw @s [{"text":"  Planned copies: ","color":"gray"},{"score":{"name":"$clone_total","objective":"whimc.dummy"},"color":"yellow"}]
title @s actionbar [{"text":"Cascade clone in progress...","color":"aqua"}]

scoreboard players operation $x_iter whimc.dummy = $temp whimc.barrelbot.cascade.x
execute as @e[type=text_display,limit=1,predicate=whimc:barrelbot/match_id,tag=whimc.barrelbot.puzzle_manager] at @s run function whimc:barrelbot/clone/cascade/iterate_x_wrapper with storage whimc:macro jump

execute store result score $clone_end_time whimc.dummy run time query gametime
scoreboard players operation $clone_elapsed whimc.dummy = $clone_end_time whimc.dummy
scoreboard players operation $clone_elapsed whimc.dummy -= $clone_start_time whimc.dummy
# Convert ticks to tenths of a second for display (ticks/2 = tenths? No: 20 ticks = 1s, so ticks/2 = tenths)
scoreboard players operation $clone_tenths whimc.dummy = $clone_elapsed whimc.dummy
scoreboard players operation $clone_tenths whimc.dummy /= #2 whimc.const

tellraw @s [{"text":"[Barrelbot] Cascade clone complete","color":"green","bold":true}]
tellraw @s [{"text":"  Puzzle: ","color":"gray"},{"nbt":"puzzle_name","storage":"whimc:storage","color":"gold"}]
tellraw @s [{"text":"  Copies: ","color":"gray"},{"score":{"name":"$clone_successes","objective":"whimc.dummy"},"color":"yellow"},{"text":" ok, ","color":"gray"},{"score":{"name":"$clone_failures","objective":"whimc.dummy"},"color":"red"},{"text":" failed","color":"gray"}]
tellraw @s [{"text":"  Time: ","color":"gray"},{"score":{"name":"$clone_elapsed","objective":"whimc.dummy"},"color":"yellow"},{"text":" ticks","color":"dark_gray"}]
execute if score $clone_failures whimc.dummy matches 1.. run tellraw @s [{"text":"  Tip: ","color":"gold"},{"text":"Failures often mean destination chunks were unloaded or bots failed to initialize. Re-run after standing near the destination, or check forceload warnings above.","color":"gray"}]
title @s actionbar [{"text":"Cascade done: ","color":"green"},{"score":{"name":"$clone_successes","objective":"whimc.dummy"},"color":"yellow"},{"text":" copies","color":"gray"}]

tag @s remove whimc.clone_operator
