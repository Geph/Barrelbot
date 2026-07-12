#> whimc:barrelbot/editor/edit_wand/edit_mode/pages/get_linked_puzzle
#   Reports the selected instructor's linked puzzle info

scoreboard players operation $temp whimc.barrelbot.edit_instance_id = @s whimc.barrelbot.edit_instance_id

execute unless entity @e[type=item_display,tag=whimc.instructor,predicate=whimc:barrelbot/match_edit_id,limit=1] run tellraw @s [{"text":"[Barrelbot] ","color":"red","bold":true},{"text":"No instructor selected. Scan an instructor with the edit wand first.","color":"gray","bold":false}]
execute unless entity @e[type=item_display,tag=whimc.instructor,predicate=whimc:barrelbot/match_edit_id,limit=1] run return 0

execute as @e[type=item_display,tag=whimc.instructor,predicate=whimc:barrelbot/match_edit_id,limit=1] run function whimc:barrelbot/editor/edit_wand/report_linked_puzzle
