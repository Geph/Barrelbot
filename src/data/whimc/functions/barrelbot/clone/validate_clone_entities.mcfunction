#> whimc:barrelbot/clone/validate_clone_entities
#   Macro: min_x/y/z + vol_* from get_dimensions (world coords of the manager being validated)

$execute as @e[type=minecraft:item_display,tag=whimc.barrelbot,x=$(min_x),y=$(min_y),z=$(min_z),dx=$(vol_x),dy=$(vol_y),dz=$(vol_z)] run function whimc:barrelbot/clone/validate_one_bot
$execute as @e[type=minecraft:item_display,tag=whimc.instructor,x=$(min_x),y=$(min_y),z=$(min_z),dx=$(vol_x),dy=$(vol_y),dz=$(vol_z)] run function whimc:barrelbot/clone/validate_one_instructor
