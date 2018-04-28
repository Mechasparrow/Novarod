extends Node2D

# Simple script that just makes sure that the player can exit back to the main menu after reaching the good(or bad) ending

# Loads the menu "level"
onready var menu = preload("res://_Scenes/Navigation/Menu.tscn")


func _process(delta):

	# Check if the user hit the space key to go home
	var go_home = Input.is_action_pressed("jump")

	# Goes back to main menu
	if (go_home):
		get_tree().change_scene_to(menu)