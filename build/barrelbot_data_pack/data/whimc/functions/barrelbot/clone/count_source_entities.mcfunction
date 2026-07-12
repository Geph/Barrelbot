#> whimc:barrelbot/clone/count_source_entities
#   Counts bots/instructors in the SOURCE puzzle before cloning (as manager).

function whimc:barrelbot/manager/get_dimensions
scoreboard players set $expected_bots whimc.dummy 0
scoreboard players set $expected_instructors whimc.dummy 0
function whimc:barrelbot/clone/count_source_entities_macro with storage whimc:macro Pos
