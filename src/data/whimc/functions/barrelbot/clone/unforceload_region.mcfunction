#> whimc:barrelbot/clone/unforceload_region
#   Removes temporary forceloads. Same score inputs as forceload_region.

scoreboard players operation $fl_x whimc.dummy = $fl_min_x whimc.dummy
function whimc:barrelbot/clone/unforceload_region_x
