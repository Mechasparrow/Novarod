extends Node2D

# Script that displays the current level of experience achieved

# Get the player info to retrieve the current xp level and xp amnt
onready var player_info = get_node("/root/playerinfo")

# For every loop
# get the current xp
# Display that experience

func _process(delta):

	var current_xp = player_info.xp

	display_xp(current_xp)

# Display the xp as a progress bar ratio of xp:max_xp
# if above max_xp, add to the player_info xp level, and clear xp to 0
# Display similar progress bar to health, but green
# Also has a label displaying the current xp level

func display_xp(xp):

	var max_xp = player_info.max_xp

	if (xp >= max_xp):
		player_info.xp = 0
		player_info.lvl += 1
	
	
	get_node("TextureProgress").value = (100/max_xp)*xp
	get_node("Level").text = str(player_info.lvl)

	
	pass