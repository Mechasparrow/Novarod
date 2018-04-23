extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var menu = preload("res://_Scenes/Navigation/Menu.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):

	# Check if the user hit the space key to go home
	var go_home = Input.is_action_pressed("jump")

	# Goes back to main menu
	if (go_home):
		get_tree().change_scene_to(menu)