extends Node

# Main menu script

var level_select = preload("res://_Scenes/Navigation/Level_Select.tscn")

# Exits the game
func exit_btn_press():
		
	get_tree().quit()

# Enters the level select screen
func start_btn_press():
	
	get_tree().change_scene_to(level_select)
