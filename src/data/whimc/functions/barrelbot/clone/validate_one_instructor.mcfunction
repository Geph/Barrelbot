#> whimc:barrelbot/clone/validate_one_instructor

scoreboard players add $instructor_count whimc.dummy 1
execute store result score $has_items whimc.dummy if data entity @s item.tag.Items[0]
execute if score $has_items whimc.dummy matches 0 run scoreboard players add $instructor_empty whimc.dummy 1
