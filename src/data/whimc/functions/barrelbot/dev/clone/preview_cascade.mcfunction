#> whimc:barrelbot/dev/clone/preview_cascade
#   Placeholder preview for cascade clone (was previously a dead link)

tellraw @s [{"text":"[Barrelbot] Cascade preview is not implemented yet.","color":"gold","bold":true}]
tellraw @s [{"text":"  Use Paste to run the cascade. Destination chunks will be temporarily forceloaded during cloning.","color":"gray","bold":false}]
execute unless entity @e[type=text_display,tag=whimc.barrelbot.puzzle_manager,predicate=whimc:barrelbot/match_id] run tellraw @s [{"text":"  Warning: ","color":"red"},{"text":"You are not linked to a puzzle.","color":"gray"}]
