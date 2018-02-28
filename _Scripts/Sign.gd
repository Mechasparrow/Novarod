extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

onready var popup = get_node("CanvasLayer/PopupPanel")

func on_body_enter( body ):
	
	if (body.name == "Player"):
		popup.popup()
	
	pass # replace with function body


func on_body_exit( body ):
	
	if (body.name == "Player"):
		popup.hide()
		
	pass # replace with function body
