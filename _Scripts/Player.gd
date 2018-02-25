
extends KinematicBody2D

# This demo shows how to build a kinematic controller.

# Member variables
const GRAVITY = 700.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
var WALK_FORCE
var WALK_MIN_SPEED
var WALK_MAX_SPEED
var STOP_FORCE
var JUMP_SPEED
var JUMP_MAX_AIRBORNE_TIME
var SLIDING_DURATION
var SLIDE_STOP_VELOCITY
var SLIDE_STOP_MIN_TRAVEL

var velocity = Vector2()
var on_air_time = 100
var on_air_time_wall = 100
var jumping = false
var wall_jumping = false
var sliding = false
var sliding_time = 0
var dir = "right"
var getting_up = false
var prev_jump_pressed = false

onready var anim = get_node("AnimatedSprite")
onready var serious_anim = get_node("AnimationPlayer")
onready var hitbox = get_node("Hitbox")

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
	
	if (sliding == true and is_on_floor() == false):
		WALK_MAX_SPEED += 400
	
	if (sliding == true and is_on_floor() == true):
		sliding_time += delta
		WALK_MAX_SPEED += 200

			
	if (slide == true and sliding == false and not is_on_floor()):
		sliding = true
		sliding_time = 0
		
		if (dir == "right"):
			serious_anim.play("Slide_Right") 
		elif (dir == "left"):
			serious_anim.play("Slide_Left")
	
	if (sliding == true and is_on_floor() and not getting_up and (sliding_time > SLIDING_DURATION or jump)):
		getting_up = true

		if (dir == "right"):
			serious_anim.play_backwards("Slide_Right")
			anim.play("still")
		elif (dir == "left"):

			serious_anim.play_backwards("Slide_Left")
			anim.play("still")
		
			
	if (getting_up and not serious_anim.is_playing()):
		getting_up = false
		sliding = false
			
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
		if (anim.is_playing() == false or anim.animation == "still" and sliding == false):
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
	
	if is_on_wall() and not is_on_floor():
		on_air_time_wall = 0
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
		wall_jumping = false
		
		if (sliding == false):
			anim.play("still")
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping and not sliding:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
			
		jumping = true

		if (on_air_time_wall < JUMP_MAX_AIRBORNE_TIME and not wall_jumping):
			if (dir == "left"):
				velocity.x = JUMP_SPEED
			elif (dir == "right"):
				velocity.x = -JUMP_SPEED
				
		anim.play("jump")
	
	on_air_time += delta
	on_air_time_wall += delta
	prev_jump_pressed = jump

	var k_collision = null


	var touched_node = ""
	
	#Collide collision
	var hit_bodies = hitbox.get_overlapping_bodies()
	
	for body in hit_bodies:
		if (body.name != name):
			check_collided_body(body)

	#Check up
	check_powerups()
	
	if (get_node("/root/playerinfo").respawn == true):
		respawn()
	

func default_props():
	WALK_FORCE = 600
	WALK_MIN_SPEED = 10
	WALK_MAX_SPEED = 200
	SLIDING_DURATION = 0.25
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
	getting_up = false
	rotation = 0
	position = get_node("/root/playerinfo").spawn_point
	get_node("/root/playerinfo").respawn = false


		
func check_collided_body(body):
	
	var node_name = body.name	
	
	if (node_name == "Hazard"):
		respawn()
		take_damage(1)	
	
	if (body.is_in_group("enemy")):
		respawn()
		take_damage(1)
	
	
	pass
	

func take_damage(damage):
	
	var current_health = get_node("/root/playerinfo").health
	
	var new_health = current_health - damage
	get_node("/root/playerinfo").health = new_health