#> whimc:barrelbot/clone/prepare_destination_chunks
#   Forceload source + destination volumes for the current clone operation.
#   Expects clone_as_manager to have already computed source/dest bounds.

# Source
scoreboard players operation $fl_min_x whimc.dummy = $min_source_x whimc.dummy
scoreboard players operation $fl_min_z whimc.dummy = $min_source_z whimc.dummy
scoreboard players operation $fl_max_x whimc.dummy = $max_source_x whimc.dummy
scoreboard players operation $fl_max_z whimc.dummy = $max_source_z whimc.dummy
function whimc:barrelbot/clone/forceload_region

# Destination (offset from paste position)
scoreboard players operation $fl_min_x whimc.dummy = $min_source_x whimc.dummy
scoreboard players operation $fl_min_z whimc.dummy = $min_source_z whimc.dummy
scoreboard players operation $fl_max_x whimc.dummy = $max_source_x whimc.dummy
scoreboard players operation $fl_max_z whimc.dummy = $max_source_z whimc.dummy
scoreboard players operation $fl_min_x whimc.dummy -= $source_x whimc.dummy
scoreboard players operation $fl_min_z whimc.dummy -= $source_z whimc.dummy
scoreboard players operation $fl_max_x whimc.dummy -= $source_x whimc.dummy
scoreboard players operation $fl_max_z whimc.dummy -= $source_z whimc.dummy
scoreboard players operation $fl_min_x whimc.dummy += $paste_x whimc.dummy
scoreboard players operation $fl_min_z whimc.dummy += $paste_z whimc.dummy
scoreboard players operation $fl_max_x whimc.dummy += $paste_x whimc.dummy
scoreboard players operation $fl_max_z whimc.dummy += $paste_z whimc.dummy
function whimc:barrelbot/clone/forceload_region

# Remember dest bounds for later unload
scoreboard players operation $clone_dest_min_x whimc.dummy = $fl_min_x whimc.dummy
scoreboard players operation $clone_dest_min_z whimc.dummy = $fl_min_z whimc.dummy
scoreboard players operation $clone_dest_max_x whimc.dummy = $fl_max_x whimc.dummy
scoreboard players operation $clone_dest_max_z whimc.dummy = $fl_max_z whimc.dummy
