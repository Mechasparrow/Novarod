extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):

	var current_time = get_node("/root/playerinfo").timer
	var timer_label = get_node("Label")
	
	timer_label.text = "Time: %.2f" % current_time
