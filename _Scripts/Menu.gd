extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var level_one = preload("res://_Scenes/Level_1.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_Exit_btn_pressed():
	
	get_tree().quit()
	
	pass # replace with function body
	
	


func _on_Start_btn_pressed():
	
	var node = level_one.instance()
	get_tree().change_scene_to(level_one)
	
	pass # replace with function body
