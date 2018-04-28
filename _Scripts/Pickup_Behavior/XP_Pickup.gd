extends RigidBody2D

# Gets the hitbox for the XP orb
onready var xp_hitbox = get_node("Hitbox")

# Checks if the player has collided with the XP_Orb
# If it has, then add the xp to the player_info global variable
# Destroy the xp orb after it has been collected
func _physics_process(delta):
	var bodies = xp_hitbox.get_overlapping_bodies()
	var areas = xp_hitbox.get_overlapping_areas()

	var colliders = bodies + areas

	for collider in colliders:
		if (collider.is_in_group("player")):
			print ("XP BABY")
			var player = collider
			var player_props = collider.player_info
			player_props.xp += 1
			queue_free()
			pass