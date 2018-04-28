extends Area2D

# Main Script that handles weapon pickups

# The weapon and the weapon texture that will be collected
var weapon
var weapon_texture

# Animator for the weapon bobbing animation
onready var animator = get_nnode("AnimationPlayer")

func _ready():

	# Gets the specific weapon that will be inserted into the weapon pickup
	# When the player picks up the weapon pickup this is the weapon they will recieve
	# In this case, it is a sword
	
	var sword_prefab = get_node("/root/weapons").weapons[0]
	var sword = sword_prefab.instance()
	var sword_texture = sword.get_node("Sprite").texture
	
	set_weapon(sword_prefab, sword_texture)
	
	# Play the pickup bobin animation
	animator.play("Bobin")
	
	
	pass

# Sets the weapon of the weapon pickup
func set_weapon(wpn, weapon_txtre):
	weapon = wpn
	weapon_texture = weapon_txtre
	get_node("WeaponHolder/WeaponSprite").texture = weapon_texture
	
	pass


# If the player collides with the weapon pickup
# The player will equip the weapon and it will appear in their inventory
# the weapon pickup will vanish so it can be no longer be picked up again

func _process(delta):

	var bodies = get_overlapping_bodies()
	var areas =get_overlapping_areas()
	
	var colliders = bodies + areas
		
	for collider in colliders:
		if (collider.is_in_group("player")):
			var player = collider
			var player_props = player.player_info
			player_props.set_current_weapon(weapon)
			player.check_weapons()
			queue_free()

	pass
