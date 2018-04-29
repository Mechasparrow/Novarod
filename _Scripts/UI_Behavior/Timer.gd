extends Node2D

# Simple Script that displays the time since the level started

# Gets the time since level started from player_props
# Writes the time to a UI Label

func _process(delta):

	var current_time = get_node("/root/playerinfo").timer
	var timer_label = get_node("Label")
	
	timer_label.text = "Time: %.2f" % current_time
