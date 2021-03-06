extends RigidBody2D

# Exactly the same Player_Bullet.gd

onready var anim_sprite = get_node("Sprite")

var knockback_factor = 400
var damage = 1
var attack_dir = "null"

func shoot(dir, velx):

	if (dir == "left"):
		linear_velocity.x = -velx
		anim_sprite.flip_v = true
		attack_dir = "left"
		pass
	elif (dir == "right"):
		linear_velocity.x = velx
		anim_sprite.flip_v = false
		attack_dir = "right"
		pass

	pass

func _physics_process(delta):

	var bodies = get_node("Hitbox").get_overlapping_bodies()
	for body in bodies:
		if body.name != name:
			if (!body.is_in_group("cage")):
				queue_free()

	pass

func _process(delta):

	pass