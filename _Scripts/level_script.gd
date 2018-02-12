extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var win_text = get_node("HUD/Win Text")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func on_goal_enter( body ):
	if (body.name == "Player"):
		win_text.show()
	
	pass # replace with function body
