#> whimc:barrelbot/editor/edit_wand/instructor_found
#   Opens the instructor edit page when scanning an instructor

scoreboard players set #success whimc.dummy 1

data remove storage whimc:macro page
data modify storage whimc:macro page.page set value "instructor"
scoreboard players operation @s whimc.barrelbot.edit_instance_id = $temp whimc.barrelbot.edit_instance_id

tag @s add whimc.edit_subject

# Keep existing linking / item definition side effects
execute at @s run function whimc:barrelbot/no_smuggle/define_items
function whimc:barrelbot/block/instructor/get_linked_puzzle
playsound minecraft:entity.player.levelup block @a ~ ~ ~ 1 2
