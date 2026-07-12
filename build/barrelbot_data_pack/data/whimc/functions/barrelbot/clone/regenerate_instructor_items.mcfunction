#> whimc:barrelbot/clone/regenerate_instructor_items

scoreboard players add $arrows_missing whimc.dummy 1
data modify block ~ ~ ~ Items set from entity @s item.tag.Items
execute if data block ~ ~ ~ Items[0] run scoreboard players add $arrows_restored whimc.dummy 1
function whimc:barrelbot/no_smuggle/define_items
