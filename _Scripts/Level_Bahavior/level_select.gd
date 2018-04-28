extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# Get all the level selection buttons
onready var buttons = get_tree().get_nodes_in_group("select_button")

# Get all the levels
onready var levels = get_node("/root/level_data").levels

func _process(delta):

	# check if any of the buttons have been pressed
	# if so find out what level selection button it is
	# redirect to the corresponding level
	
	for button in buttons:
		if (button.is_pressed() == true):
			print ("True")
			var level = button.level
			var type = button.type
		
			var level_scn = get_node("/root/level_data").generate_level_path(type, level)
			
			print (level_scn)
			
			get_tree().change_scene_to(level_scn)

	pass
