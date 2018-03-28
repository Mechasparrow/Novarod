extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var buttons = get_tree().get_nodes_in_group("select_button")

onready var levels = get_node("/root/level_data").levels

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):

	for button in buttons:
		if (button.is_pressed() == true):
			print ("True")
			var level = button.level
			var type = button.type
		
			var level_scn = get_node("/root/level_data").generate_level_path(type, level)
			
			print (level_scn)
			
			get_tree().change_scene_to(level_scn)

	pass
