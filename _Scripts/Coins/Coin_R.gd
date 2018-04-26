extends Area2D

# Same as Coin.gd


var collected = false

func _ready():
	set_physics_process(true)
	pass

func _physics_process(delta):
	
	var bodies = get_overlapping_bodies()

	var player_info = get_node("/root/playerinfo")

	# Checks colliding bodies for player
	# if it collides with the player
	# Add a coin to their amnt of coins and destroy itself
	
	for body in bodies:
		if body.name == "Player" and collected == false:
			player_info.coins_r += 1
			queue_free()
			collected = true
