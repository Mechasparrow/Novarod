extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var anim_sprite = get_node("Sprite")

var knockback_factor = 400
var damage = 1
var attack_dir = "null"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	pass

func shoot_diagonal(dir, velx, vely):
	shoot(dir, velx)
	linear_velocity.y = vely

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

func _process(delta):

	pass