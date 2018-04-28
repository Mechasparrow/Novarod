extends Node2D

# Script in charge of handling interaction with the alternative ending door at the crumbling village level

# Get the world node
onready var world = get_tree().get_root().get_node("World")

# variable for the door object
var evil_ending_door

func _ready():
	
	# Retrieve the alternative ending door for the crumbling village
	evil_ending_door = world.get_node("Evil_Door")
	
	pass

func _process(delta):
	
	var interact = Input.is_action_pressed("interact")
	var player_at_door = evil_ending_door.player_here
	
	# See if the player is at the door and is interacting with it
	# if so send the player to the bad ending
	
	if (interact and player_at_door):
		send_to_bad_ending()
		pass
	
	
	
	pass

# Sends the player to bad ending scene
func send_to_bad_ending():
	var bad_ending = load("res://_Scenes/Navigation/Bad_Ending.tscn")
	get_tree().change_scene_to(bad_ending)