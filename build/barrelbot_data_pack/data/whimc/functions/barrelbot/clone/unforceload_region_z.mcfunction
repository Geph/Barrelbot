#> whimc:barrelbot/clone/unforceload_region_z

execute store result storage whimc:macro forceload.x int 1 run scoreboard players get $fl_x whimc.dummy
execute store result storage whimc:macro forceload.z int 1 run scoreboard players get $fl_z whimc.dummy
function whimc:barrelbot/clone/forceload_remove with storage whimc:macro forceload

scoreboard players add $fl_z whimc.dummy 16
execute if score $fl_z whimc.dummy <= $fl_max_z whimc.dummy run function whimc:barrelbot/clone/unforceload_region_z
