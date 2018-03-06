extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var speed = 100
var dir = "up"

var movement_timer = 0
var movement_duration = 2.0

onready var platform_hitbox = get_node("Hitbox")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):

	if (dir == "up"):
		position.y -= speed * delta
		pass
	elif (dir == "down"):
		position.y += speed * delta
		pass

	movement_timer += delta

	if (movement_timer > movement_duration):
		if (dir == "down"):
			dir = "up"
			movement_timer = 0
		elif (dir == "up"):
			dir = "down"
			movement_timer = 0


	var platform_bodies = platform_hitbox.get_overlapping_bodies()

	for body in platform_bodies:
		if (body.name == "Player"):
			var body_position = body.position

			if (dir == "up"):
				body_position.y -= speed * delta
	
			elif (dir == "down"):
				body_position.y += speed * delta

