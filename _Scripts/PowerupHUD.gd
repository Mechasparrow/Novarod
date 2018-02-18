extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
		
	var power_up_label = get_node("Label")
	var current_power_up = get_node("/root/playerinfo").power_up
	
	if (str(current_power_up) == "Null"):
		current_power_up = "None"
	
	power_up_label.text = "Powerup: " + str(current_power_up)

