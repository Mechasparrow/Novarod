extends Area2D

# Script that is a spin off of Weapon_Pickup.gd
# Main difference is that the weapon is a gun instead of a sword

var weapon
var weapon_texture

onready var animator = get_node("AnimationPlayer")

func _ready():

	# Set the weapon pickup to the gun player weapon
	var gun_prefab = get_node("/root/weapons").weapons[1]
	var gun = gun_prefab.instance()
	var gun_texture = gun.get_node("Sprite").texture

	set_weapon(gun_prefab, gun_texture)

	animator.play("Bobin")


	pass

func set_weapon(wpn, weapon_txtre):
	weapon = wpn
	weapon_texture = weapon_txtre
	get_node("WeaponHolder/WeaponSprite").texture = weapon_texture

	pass

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


