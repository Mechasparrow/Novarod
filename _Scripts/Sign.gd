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


func on_body_enter( body ):
	
	if (body.name == "Player"):
		get_node("Panel").show()
	
	pass # replace with function body


func on_body_exit( body ):
	
	if (body.name == "Player"):
		get_node("Panel").hide()
	
	pass # replace with function body
