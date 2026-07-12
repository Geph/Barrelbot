#> whimc:barrelbot/clone/check_instructor_arrows
#   As instructor at its block. Compare block inventory vs stored Items.

# If block inventory is empty but stored Items exist, restore
execute unless data block ~ ~ ~ Items[0] if data entity @s item.tag.Items[0] run function whimc:barrelbot/clone/regenerate_instructor_items

# If both empty, flag missing when source expected items
execute unless data block ~ ~ ~ Items[0] unless data entity @s item.tag.Items[0] run scoreboard players add $arrows_missing whimc.dummy 1

# If block has items but entity cache is empty, redefine
execute if data block ~ ~ ~ Items[0] unless data entity @s item.tag.Items[0] run function whimc:barrelbot/no_smuggle/define_items
