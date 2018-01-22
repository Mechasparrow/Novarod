extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const GRAVITY = 200.0
const WALK_SPEED = 200

var velocity = Vector2()

func _fixed_process(delta):
	
	var body = get_node("Body")
	
	velocity.y += delta * GRAVITY
	if (Input.is_action_pressed("ui_left")):
        velocity.x = - WALK_SPEED
	elif (Input.is_action_pressed("ui_right")):
        velocity.x =   WALK_SPEED
	else:
        velocity.x = 0

	var motion = velocity * delta
	motion = body.move(motion)

	if (body.is_colliding()):
		var n = body.get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		body.move(motion)

	
	pass

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
