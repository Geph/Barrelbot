#> whimc:barrelbot/clone/unforceload_region_x

scoreboard players operation $fl_z whimc.dummy = $fl_min_z whimc.dummy
function whimc:barrelbot/clone/unforceload_region_z

scoreboard players add $fl_x whimc.dummy 16
execute if score $fl_x whimc.dummy <= $fl_max_x whimc.dummy run function whimc:barrelbot/clone/unforceload_region_x
