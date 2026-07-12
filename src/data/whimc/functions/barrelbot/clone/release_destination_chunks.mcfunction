#> whimc:barrelbot/clone/release_destination_chunks
#   Releases temporary destination forceloads from the last clone.

scoreboard players operation $fl_min_x whimc.dummy = $clone_dest_min_x whimc.dummy
scoreboard players operation $fl_min_z whimc.dummy = $clone_dest_min_z whimc.dummy
scoreboard players operation $fl_max_x whimc.dummy = $clone_dest_max_x whimc.dummy
scoreboard players operation $fl_max_z whimc.dummy = $clone_dest_max_z whimc.dummy
function whimc:barrelbot/clone/unforceload_region
