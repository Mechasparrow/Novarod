extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var win_text = get_node("HUD/Win Text")
var level_end = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):

	var current_time = get_node("/root/playerinfo").timer

	if (level_end == false): 
		current_time+= delta
		get_node("/root/playerinfo").timer = current_time
		print (current_time)
	else:
		print ("LEVEL END")

	pass


func on_goal_enter( body ):
	if (body.name == "Player"):
		win_text.show()
		level_end = true
			
	pass # replace with function body
