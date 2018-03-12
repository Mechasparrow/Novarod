extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var speed = 300
var dir = "left"

var movement_timer = 0
var movement_duration = 2.0

onready var platform_hitbox = get_node("Hitbox")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	
	if (dir == "left"):
		position.x -= speed * delta
		pass
	elif (dir == "right"):
		position.x += speed * delta
		pass
	
	movement_timer += delta
	
	if (movement_timer > movement_duration):
		if (dir == "left"):
			dir = "right"
			movement_timer = 0
		elif (dir == "right"):
			dir = "left"
			movement_timer = 0
	
	
	var platform_bodies = platform_hitbox.get_overlapping_bodies()
	
	for body in platform_bodies:
		var body_position = body.position
		
		if (dir == "left"):
			body_position.x -= speed * delta * 1.5
			
		elif (dir == "right"):
			body_position.x += speed * delta * 1.5
	
