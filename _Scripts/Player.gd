
extends KinematicBody2D

# This demo shows how to build a kinematic controller.

# Member variables
const GRAVITY = 500.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 300
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false

var health = 3

onready var anim = get_node("AnimatedSprite")

signal health_changed(health)

func _ready():
	emit_signal("health_changed", health)

func _physics_process(delta):
	
	
	
	# Create forces
	var force = Vector2(0, GRAVITY)
	
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	
	var stop = true
	
	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			anim.flip_h = true
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			anim.flip_h = false
			force.x += WALK_FORCE
			stop = false
	
	if not stop:
		if (anim.is_playing() == false or anim.animation == "still"):
			anim.play("move")
	
	if stop:
		
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	# Integrate forces to velocity
	velocity += force * delta	
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if (velocity == Vector2(0,0)):
		anim.stop()
		if (anim.is_playing() == false):
			anim.play("still")
	
	if is_on_floor():
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
		anim.play("jump")
	
	on_air_time += delta
	prev_jump_pressed = jump

	var k_collision = null


	var touched_node = ""
	
	#Collide collision
	k_collision = move_and_collide(Vector2(0,1));
	if not k_collision == null:
		
		if touched_node == "":
			touched_node = k_collision.collider.get_name()
			check_collided_node(touched_node)

	# Slide collision
	if (get_slide_count() > 0):
		k_collision = get_slide_collision(0)
		
	if not k_collision == null:
		
		if touched_node == "":
			touched_node = k_collision.collider.get_name()
			check_collided_node(touched_node)
		
		
func respawn():
	
	position = Vector2(100,400)
		
		
func check_collided_node(node_name):
	print (node_name)
	
	if (node_name == "Hazard"):
		print ("thats bad")
		respawn()
		take_damage(1)	
	pass
	

func take_damage(damage):
	
	health = health - damage
	emit_signal("health_changed", health)