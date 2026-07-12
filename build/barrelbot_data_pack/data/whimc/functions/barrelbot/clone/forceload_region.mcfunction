#> whimc:barrelbot/clone/forceload_region
#   Forceloads chunks covering a bounding box so clone/entity ops don't hit unloaded chunks.
#   Inputs (scores): $fl_min_x $fl_min_z $fl_max_x $fl_max_z

scoreboard players operation $fl_x whimc.dummy = $fl_min_x whimc.dummy
function whimc:barrelbot/clone/forceload_region_x
