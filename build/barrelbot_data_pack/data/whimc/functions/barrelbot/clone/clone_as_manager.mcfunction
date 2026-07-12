#> whimc:barrelbot/clone/clone_as_manager
#   Clones all the stuff
#   Executed as puzzle manager, at player (or cascade destination)

scoreboard players operation $temp whimc.barrelbot.puzzle_type_id = @s whimc.barrelbot.puzzle_type_id
execute store result storage whimc:macro puzzle_type int 1 run scoreboard players get @s whimc.barrelbot.puzzle_type_id
function whimc:barrelbot/manager/get_puzzle_name

scoreboard players add $clone_index whimc.dummy 1
execute if score $clone_total whimc.dummy matches 1.. run tellraw @a[tag=whimc.clone_operator] [{"text":"[Barrelbot] Preparing clone ","color":"aqua"},{"score":{"name":"$clone_index","objective":"whimc.dummy"},"color":"yellow"},{"text":" of ","color":"aqua"},{"score":{"name":"$clone_total","objective":"whimc.dummy"},"color":"yellow"},{"text":"...","color":"aqua"}]
execute if score $clone_total whimc.dummy matches 1.. run tellraw @a[tag=whimc.clone_operator] [{"text":"  Puzzle: ","color":"gray"},{"nbt":"puzzle_name","storage":"whimc:storage","color":"gold"}]

#Get data from marker
execute on passengers run data modify storage whimc:storage clone.success_function set from entity @s data.success_function
function whimc:barrelbot/manager/get_dimensions
scoreboard players operation $min_source_x whimc.dummy = $real_min_x whimc.dummy
scoreboard players operation $min_source_y whimc.dummy = $real_min_y whimc.dummy
scoreboard players operation $min_source_z whimc.dummy = $real_min_z whimc.dummy
scoreboard players operation $max_source_x whimc.dummy = $real_max_x whimc.dummy
scoreboard players operation $max_source_y whimc.dummy = $real_max_y whimc.dummy
scoreboard players operation $max_source_z whimc.dummy = $real_max_z whimc.dummy
scoreboard players operation $vol_x whimc.dummy = $size_x whimc.dummy
scoreboard players operation $vol_y whimc.dummy = $size_y whimc.dummy
scoreboard players operation $vol_z whimc.dummy = $size_z whimc.dummy

#Get coordinates
execute store result score $source_x whimc.dummy run data get entity @s Pos[0]
execute store result score $source_y whimc.dummy run data get entity @s Pos[1]
execute store result score $source_z whimc.dummy run data get entity @s Pos[2]

# Count expected entities before cloning
function whimc:barrelbot/clone/count_source_entities

# Ensure source + destination chunks are loaded
tellraw @a[tag=whimc.clone_operator] [{"text":"  Loading destination chunks...","color":"dark_gray"}]
function whimc:barrelbot/clone/prepare_destination_chunks

#Clone blocks
tellraw @a[tag=whimc.clone_operator] [{"text":"  Cloning blocks...","color":"dark_gray"}]
function whimc:barrelbot/clone/clone_blocks

#Summon new puzzle marker
tellraw @a[tag=whimc.clone_operator] [{"text":"  Linking puzzle manager...","color":"dark_gray"}]
execute on passengers run data modify storage whimc:storage bounding_box set from entity @s data.bounding_box
execute store result score $max_x whimc.dummy run data get storage whimc:storage bounding_box.max_x
execute store result score $max_y whimc.dummy run data get storage whimc:storage bounding_box.max_y
execute store result score $max_z whimc.dummy run data get storage whimc:storage bounding_box.max_z
execute store result score $min_x whimc.dummy run data get storage whimc:storage bounding_box.min_x
execute store result score $min_y whimc.dummy run data get storage whimc:storage bounding_box.min_y
execute store result score $min_z whimc.dummy run data get storage whimc:storage bounding_box.min_z
execute rotated as @s run function whimc:barrelbot/clone/spawn_manager

#Clone entities
tellraw @a[tag=whimc.clone_operator] [{"text":"  Initializing Barrelbots...","color":"dark_gray"}]
function whimc:barrelbot/manager/get_dimensions
function whimc:barrelbot/clone/delete_old_entities with storage whimc:macro Pos
function whimc:barrelbot/clone/clone_entities with storage whimc:macro Pos

# Validate the newly spawned manager
execute as @e[type=text_display,tag=whimc.barrelbot.puzzle_manager] if score @s whimc.barrelbot.puzzle_id = $new_id whimc.barrelbot.puzzle_id at @s run function whimc:barrelbot/clone/validate_clone

execute if score $clone_valid whimc.dummy matches 0 run scoreboard players add $clone_failures whimc.dummy 1
execute if score $clone_valid whimc.dummy matches 0 run tellraw @a[tag=whimc.clone_operator] [{"text":"[Barrelbot] Clone ","color":"red","bold":true},{"score":{"name":"$clone_index","objective":"whimc.dummy"},"color":"yellow","bold":false},{"text":" FAILED","color":"red","bold":true},{"text":" at paste (","color":"gray","bold":false},{"score":{"name":"$paste_x","objective":"whimc.dummy"},"color":"yellow"},{"text":", ","color":"gray"},{"score":{"name":"$paste_y","objective":"whimc.dummy"},"color":"yellow"},{"text":", ","color":"gray"},{"score":{"name":"$paste_z","objective":"whimc.dummy"},"color":"yellow"},{"text":")","color":"gray"}]
execute if score $clone_valid whimc.dummy matches 1 run scoreboard players add $clone_successes whimc.dummy 1

# Release temporary destination forceload (keep source loaded during cascade)
function whimc:barrelbot/clone/release_destination_chunks
