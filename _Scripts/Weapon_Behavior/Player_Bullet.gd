extends RigidBody2D

# Base code for all projectiles

# Projectile animation
onready var anim_sprite = get_node("AnimatedSprite")

# Projectile violence variables
var knockback_factor = 2000
var damage = 1
var attack_dir = "null"

# Function for shooting the projectile
# Takes in the direction and the speed of the projectile
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

# Checks if the projectile hits anything. If so destroy the projectile.
func _physics_process(delta):
	
	var bodies = get_node("Hitbox").get_overlapping_bodies()
	for body in bodies:
		if body.name != name:
			queue_free()
	
	pass