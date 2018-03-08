extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var anim_sprite = get_node("AnimatedSprite")

var knockback_factor = 2000
var damage = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	shoot("right", 250)
	pass

func shoot(dir, velx):
	
	if (dir == "left"):
		anim_sprite.flip_h = true
		linear_velocity.x = -velx
		pass
	elif (dir == "right"):
		anim_sprite.flip_h = false
		linear_velocity.x = velx
		pass
	
	pass


func _process(delta):

	var bodies = get_colliding_bodies()

	if (len (bodies) > 0):
		queue_free()
