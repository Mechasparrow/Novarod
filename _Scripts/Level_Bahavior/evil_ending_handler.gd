extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var world = get_tree().get_root().get_node("World")
var evil_ending_door

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	evil_ending_door = world.get_node("Evil_Door")
	
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	var interact = Input.is_action_pressed("interact")
	var player_at_door = evil_ending_door.player_here
	
	if (interact and player_at_door):
		send_to_bad_ending()
		pass
	
	
	
	pass

func send_to_bad_ending():
	var bad_ending = load("res://_Scenes/Navigation/Bad_Ending.tscn")
	get_tree().change_scene_to(bad_ending)