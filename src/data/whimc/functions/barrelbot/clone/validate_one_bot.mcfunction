#> whimc:barrelbot/clone/validate_one_bot

scoreboard players add $bot_count whimc.dummy 1
execute on passengers store result score $has_code whimc.dummy if data entity @s data.instructions[0]
execute if score $has_code whimc.dummy matches 1 run scoreboard players add $bot_with_code whimc.dummy 1
execute if score $has_code whimc.dummy matches 0 run scoreboard players add $bot_missing_code whimc.dummy 1
