extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# Default amount of health added
var health_added = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):

	# Check for a collision with a player
	var bodies = get_overlapping_bodies()

	for body in bodies:
		if (body.is_in_group("player")):

			var player = body
			var player_info = player.player_info

			if (player_info.health < player_info.max_health):
				player_info.health += 1
				queue_free()

			# Add the health to the player
			pass
