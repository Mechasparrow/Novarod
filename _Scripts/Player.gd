extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const GRAVITY = 500.0
const WALK_SPEED = 200

var velocity = Vector2()

var jump_timer = 0
var jump_duration = 1.2
var jumping = false

func _fixed_process(delta):

	jump_timer += delta
	
	var body = get_node("Body")
	
	# Gravity
	velocity.y += delta * GRAVITY
	
	# Movement Code
	if (Input.is_action_pressed("ui_left")):
        velocity.x = - WALK_SPEED
	elif (Input.is_action_pressed("ui_right")):
        velocity.x =   WALK_SPEED
	else:
        velocity.x = 0

	# Jumping Code
	if (jumping == true):
		
		if (jump_timer <= 0.2):
			print ("jumping")
			velocity.y -= delta * 4000
		else: 
			print ("done jumping")
			jumping = false
			jump_timer = 0
		
		jump_timer += delta
	
	
	var motion = velocity * delta
	motion = body.move(motion)


	# Jumping
	if (body.is_colliding()):
		if (Input.is_action_pressed("ui_up")):
			
			if not (jumping):
				jumping = true
				print (jumping)

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
