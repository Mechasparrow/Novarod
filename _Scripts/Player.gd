
extends KinematicBody2D

# This demo shows how to build a kinematic controller.

# Member variables
const GRAVITY = 700.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
var WALK_FORCE = 600
var WALK_MIN_SPEED = 10
var  WALK_MAX_SPEED = 200
var STOP_FORCE = 1300
var JUMP_SPEED = 300
var JUMP_MAX_AIRBORNE_TIME = 0.2

var SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
var SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false
var sliding = false
var dir = "right"

var prev_jump_pressed = false

onready var anim = get_node("AnimatedSprite")
onready var serious_anim = get_node("AnimationPlayer")

func _ready():
	
	var current_health = get_node("/root/playerinfo").health
	
	check_powerups()
	set_physics_process(true)

func _physics_process(delta):
	
	var player_props = get_node("/root/playerinfo")
	
	# Create forces
	var force = Vector2(0, GRAVITY)
	
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	var slide = Input.is_action_pressed("slide")
	var rotating = false
	var weird_anim = false
	var getup = Input.is_action_pressed("getup")

	weird_anim = serious_anim.assigned_animation == "Slide_Left" or serious_anim.assigned_animation == "Slide_Right"

	if (sliding == true and is_on_floor() == false):
		WALK_MAX_SPEED += 400
		print (WALK_MAX_SPEED)
	
	
	if (slide == true and sliding == false and not is_on_floor()):
		sliding = true
		
		if (dir == "right"):
			serious_anim.play("Slide_Right") 
		elif (dir == "left"):

			serious_anim.play("Slide_Left")
	
	if (sliding == true and getup == true and is_on_floor()):
		sliding = false
		
		if (dir == "right"):
			serious_anim.play_backwards("Slide_Right")
			anim.play("still")
		elif (dir == "left"):

			serious_anim.play_backwards("Slide_Left")
			anim.play("still")
		
	
	var stop = true
	
	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			
			anim.flip_h = true
			dir = "left"
			
			force.x -= WALK_FORCE
			stop = false
			
			if (serious_anim.is_playing() == false and sliding == true):
				rotation_degrees = -90
			
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			
			anim.flip_h = false
			dir = "right"
			
			force.x += WALK_FORCE
			stop = false
			
			if (serious_anim.is_playing() == false and sliding == true):
				rotation_degrees = 90
	
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
		anim.play("still")
	
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

	#Check up
	check_powerups()
	
	if (get_node("/root/playerinfo").respawn == true):
		respawn()
	

func default_props():
	WALK_FORCE = 600
	WALK_MIN_SPEED = 10
	WALK_MAX_SPEED = 200
	STOP_FORCE = 1300
	JUMP_SPEED = 400
	JUMP_MAX_AIRBORNE_TIME = 0.2
	
	SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
	SLIDE_STOP_MIN_TRAVEL = 1.0

func check_powerups():
	
	var power_up = get_node("/root/playerinfo").power_up
	
	if (power_up == null):
		default_props()
	elif (power_up == "speed_up"):
		default_props()
		WALK_MAX_SPEED = 500
	elif (power_up == "super_speed_up"):
		default_props()
		WALK_MAX_SPEED = 800
	elif (power_up == "jump_up"):
		default_props()
		JUMP_SPEED = 600
		
	pass
		
func respawn():
	
	anim.play("still")
	sliding = false
	rotation = 0
	position = get_node("/root/playerinfo").spawn_point
	get_node("/root/playerinfo").timer = 0
	get_node("/root/playerinfo").respawn = false


		
func check_collided_node(node_name):
	
	if (node_name == "Hazard"):
		print ("thats bad")
		respawn()
		take_damage(1)	
	pass
	

func take_damage(damage):
	
	var current_health = get_node("/root/playerinfo").health
	
	var new_health = current_health - damage
	get_node("/root/playerinfo").health = new_health