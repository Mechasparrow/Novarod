extends RigidBody2D

# Exactly the same as Player_Bullet.gd
# Can be cut in half by Sword

# Animated projectile sprite
onready var anim_sprite = get_node("Sprite")

# Projectile violence variables
var knockback_factor = 400
var damage = 1
var attack_dir = "null"

# Main function for shooting the projectile
func shoot(dir, velx):

	if (dir == "left"):
		linear_velocity.x = -velx
		anim_sprite.flip_h = true
		attack_dir = "left"
		pass
	elif (dir == "right"):
		linear_velocity.x = velx
		anim_sprite.flip_h = false
		attack_dir = "right"
		pass

	pass

func _physics_process(delta):

	var bodies = get_node("Hitbox").get_overlapping_bodies()
	var areas = get_node("Hitbox").get_overlapping_areas()
	
	for body in (bodies):
		if body.name != name:
			queue_free()

	for area in (areas):
		if area.is_in_group("weapon"):
			queue_free();

	pass