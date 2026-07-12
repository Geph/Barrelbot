#> whimc:barrelbot/clone/check_path_arrows
#   Detects missing path-offset instruction books ("arrows") in instructors.
#   Attempts regeneration from stored instructor item data.

scoreboard players set $arrows_missing whimc.dummy 0
scoreboard players set $arrows_restored whimc.dummy 0

$execute as @e[type=minecraft:item_display,tag=whimc.instructor,x=$(min_x),y=$(min_y),z=$(min_z),dx=$(vol_x),dy=$(vol_y),dz=$(vol_z)] at @s run function whimc:barrelbot/clone/check_instructor_arrows

execute if score $arrows_missing whimc.dummy matches 1.. run tellraw @a[tag=whimc.clone_operator] [{"text":"[Barrelbot] Warning: ","color":"gold","bold":true},{"text":"Missing path arrows detected.","color":"gray","bold":false}]
execute if score $arrows_missing whimc.dummy matches 1.. run tellraw @a[tag=whimc.clone_operator] [{"text":"  Puzzle: ","color":"gray"},{"nbt":"puzzle_name","storage":"whimc:storage","color":"gold"}]
execute if score $arrows_missing whimc.dummy matches 1.. run tellraw @a[tag=whimc.clone_operator] [{"text":"  Attempting regeneration...","color":"dark_gray"}]

execute if score $arrows_restored whimc.dummy matches 1.. run tellraw @a[tag=whimc.clone_operator] [{"text":"[Barrelbot] Path arrows restored.","color":"green"}]
execute if score $arrows_missing whimc.dummy matches 1.. if score $arrows_restored whimc.dummy matches 0 run tellraw @a[tag=whimc.clone_operator] [{"text":"[Barrelbot] Unable to regenerate arrows.","color":"red","bold":true},{"text":" Puzzle may require manual repair.","color":"gray","bold":false}]
execute if score $arrows_missing whimc.dummy matches 1.. if score $arrows_restored whimc.dummy matches 0 run scoreboard players set $clone_valid whimc.dummy 0
