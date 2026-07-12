#> whimc:barrelbot/clone/count_source_entities_macro

$execute as @e[type=minecraft:item_display,tag=whimc.barrelbot,x=$(min_x),y=$(min_y),z=$(min_z),dx=$(vol_x),dy=$(vol_y),dz=$(vol_z)] run scoreboard players add $expected_bots whimc.dummy 1
$execute as @e[type=minecraft:item_display,tag=whimc.instructor,x=$(min_x),y=$(min_y),z=$(min_z),dx=$(vol_x),dy=$(vol_y),dz=$(vol_z)] run scoreboard players add $expected_instructors whimc.dummy 1
