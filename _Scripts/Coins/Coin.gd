extends Area2D


# Variable to check if the coin has been collected
var collected = false

func _ready():

	set_physics_process(true)
	pass


func _physics_process(delta):
		
	var bodies = get_overlapping_bodies()
	
	var player_info = get_node("/root/playerinfo")
	
	# Runs through all colliding bodies, if it is the player
	# destroy the coin
	# Adds 1 to the amnt of coins that the player has collected
	for body in bodies:
		if body.name == "Player" and collected == false:
			player_info.coins += 1
			queue_free()
			collected = true
