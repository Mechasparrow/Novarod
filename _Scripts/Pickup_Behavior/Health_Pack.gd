extends Area2D

# Script for health pickup

# when picked up players health is increased by 1

# amnt of health added
var health_added = 1

# Checks if the player has collided with the health pickup
# Check if the player is at max health
# If not, give the player health and
# Destroy the health pickup

func _process(delta):

	# Check for a collision with a player
	var bodies = get_overlapping_bodies()

	for body in bodies:
		if (body.is_in_group("player")):

			var player = body
			var player_info = player.player_info

			# Add the health to the player
			if (player_info.health < player_info.max_health):
				player_info.health += 1
				queue_free()
