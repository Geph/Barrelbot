#> whimc:barrelbot/clone/validate_clone
#   Validates a newly cloned puzzle. Executed as the new puzzle manager.
#   Sets $clone_valid whimc.dummy to 1 on success, 0 on failure.

scoreboard players set $clone_valid whimc.dummy 1
scoreboard players operation $temp whimc.barrelbot.puzzle_id = @s whimc.barrelbot.puzzle_id
execute store result storage whimc:macro puzzle_type int 1 run scoreboard players get @s whimc.barrelbot.puzzle_type_id
function whimc:barrelbot/manager/get_puzzle_name

# Manager self-check
execute unless entity @s[tag=whimc.barrelbot.puzzle_manager] run scoreboard players set $clone_valid whimc.dummy 0
execute unless entity @s[tag=whimc.barrelbot.puzzle_manager] run tellraw @a[tag=whimc.clone_operator] [{"text":"[Barrelbot] Validation failed: ","color":"red","bold":true},{"text":"puzzle manager missing after clone.","color":"gray","bold":false}]

function whimc:barrelbot/manager/get_dimensions

# Count barrelbots in destination volume
scoreboard players set $bot_count whimc.dummy 0
scoreboard players set $bot_with_code whimc.dummy 0
scoreboard players set $bot_missing_code whimc.dummy 0
scoreboard players set $instructor_count whimc.dummy 0
scoreboard players set $instructor_empty whimc.dummy 0

function whimc:barrelbot/clone/validate_clone_entities with storage whimc:macro Pos

execute if score $expected_bots whimc.dummy matches 1.. if score $bot_count whimc.dummy matches 0 run scoreboard players set $clone_valid whimc.dummy 0
execute if score $expected_bots whimc.dummy matches 1.. if score $bot_count whimc.dummy matches 0 run tellraw @a[tag=whimc.clone_operator] [{"text":"[Barrelbot] Validation failed: ","color":"red","bold":true},{"text":"no Barrelbots found in cloned puzzle '","color":"gray","bold":false},{"nbt":"puzzle_name","storage":"whimc:storage","color":"gold"},{"text":"'. Chunks may still be unloaded.","color":"gray"}]

execute if score $bot_missing_code whimc.dummy matches 1.. run scoreboard players set $clone_valid whimc.dummy 0
execute if score $bot_missing_code whimc.dummy matches 1.. run tellraw @a[tag=whimc.clone_operator] [{"text":"[Barrelbot] Validation failed: ","color":"red","bold":true},{"score":{"name":"$bot_missing_code","objective":"whimc.dummy"},"color":"yellow","bold":false},{"text":" Barrelbot(s) have empty code in '","color":"gray"},{"nbt":"puzzle_name","storage":"whimc:storage","color":"gold"},{"text":"'.","color":"gray"}]

execute if score $expected_instructors whimc.dummy matches 1.. if score $instructor_count whimc.dummy matches 0 run scoreboard players set $clone_valid whimc.dummy 0
execute if score $expected_instructors whimc.dummy matches 1.. if score $instructor_count whimc.dummy matches 0 run tellraw @a[tag=whimc.clone_operator] [{"text":"[Barrelbot] Validation failed: ","color":"red","bold":true},{"text":"no instructors found in cloned puzzle '","color":"gray","bold":false},{"nbt":"puzzle_name","storage":"whimc:storage","color":"gold"},{"text":"'.","color":"gray"}]

# Linked type ID present
execute unless score @s whimc.barrelbot.puzzle_type_id matches 1.. run scoreboard players set $clone_valid whimc.dummy 0
execute unless score @s whimc.barrelbot.puzzle_type_id matches 1.. run tellraw @a[tag=whimc.clone_operator] [{"text":"[Barrelbot] Validation failed: ","color":"red","bold":true},{"text":"cloned manager has no puzzle_type_id.","color":"gray","bold":false}]

# Path arrow / instruction integrity on instructors
function whimc:barrelbot/clone/check_path_arrows with storage whimc:macro Pos

execute if score $clone_valid whimc.dummy matches 1 run tellraw @a[tag=whimc.clone_operator] [{"text":"[Barrelbot] Validation OK: ","color":"green","bold":true},{"nbt":"puzzle_name","storage":"whimc:storage","color":"gold","bold":false},{"text":" — ","color":"gray"},{"score":{"name":"$bot_count","objective":"whimc.dummy"},"color":"yellow"},{"text":" bots, ","color":"gray"},{"score":{"name":"$instructor_count","objective":"whimc.dummy"},"color":"yellow"},{"text":" instructors.","color":"gray"}]
