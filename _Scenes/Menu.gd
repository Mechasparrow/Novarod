extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var level_one = preload("res://_Scenes/Level_1.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass



func exit_btn_press():
		
	get_tree().quit()

func start_btn_press():
	
	get_tree().change_scene_to(level_one)
