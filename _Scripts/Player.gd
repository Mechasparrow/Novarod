
extends KinematicBody2D

# This demo shows how to build a kinematic controller.

# Member variables
var GRAVITY # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
var WALK_FORCE
var WALK_MIN_SPEED
var WALK_MAX_SPEED
var STOP_FORCE
var SLIDE_FACTOR
var JUMP_SPEED
var JUMP_MAX_AIRBORNE_TIME
var SLIDING_DURATION
var SLIDE_STOP_VELOCITY
var SLIDE_STOP_MIN_TRAVEL

var velocity = Vector2()
var on_air_time = 100
var on_air_time_wall = 100
var jumping = false
var jump = false

var wall_jumping = false
var sliding = false
var sliding_time = 0
var dir = "right"
var getting_up = false
var prev_jump_pressed = false

onready var anim = get_node("AnimatedSprite")
onready var serious_anim = get_node("AnimationPlayer")
onready var hitbox = get_node("Hitbox")
onready var climb_sprite = get_node("ClimbSprite")

onready var player_info = get_node("/root/playerinfo")
onready var weapon_holder = get_node("WeaponHolder")

var weapon = null
var weapon_offset = 5

# For combat mechanics
var player_hit = false
var hit_cooldown_duration = 0.5
var hit_timer = 0

var knockbacked = false
var knockback_vel = Vector2(0,0)
var knockback_timer = 0
var knockback_duration = 0.1

## For Wall Jumping notification
var wall_jump_notify_timer = 0
var notify_duration = 0.2

## For Icy
var iced = false
var iced_timer = 0
var iced_duration = 0.2

var in_water = false

func _ready():

	player_info.reset_player_info()

	var current_health = player_info.health

	# make sure the notification for wall jump initially not visible
	climb_sprite.visible = false

	check_weapons()
	check_powerups()
	set_physics_process(true)

func _physics_process(delta):

	var player_props = player_info

	# Check if iced
	if (iced == true and iced_timer < iced_duration):
		STOP_FORCE = STOP_FORCE / 6
		iced_timer += delta
	elif (iced == true and iced_timer > iced_duration):
		iced = false

	#Collide (Tiles) collision
	var tile_areas = hitbox.get_overlapping_areas()

	for area in tile_areas:
		if (area.name != hitbox.name):
			if (area.is_in_group("Water")):
				if (in_water == false):
					in_water = true
					velocity.y/=4

				GRAVITY = 100.0
				WALK_FORCE = 100
				JUMP_SPEED = 300

	if (len(tile_areas) == 0):
		in_water = false

	# Create forces

	var force = Vector2(0, GRAVITY)

	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	jump = Input.is_action_pressed("jump")
	var slide = Input.is_action_pressed("slide")
	var interact = Input.is_action_pressed("interact")

	if not (weapon == null):
		weapon.update_orientation(dir)
		var weapon_offset = weapon.offset

		if (weapon.is_in_group("gun")):
			if (dir == "right"):
				weapon_holder.position.x = weapon_offset
			elif (dir == "left"):
				weapon_holder.position.x = -weapon_offset

	if (interact and not (weapon == null) and not sliding and not jumping and is_on_floor()):
		var weapon_offset = weapon.offset

		if (dir == "right"):
			weapon_holder.position.x = weapon_offset
		elif (dir == "left"):
			weapon_holder.position.x = -weapon_offset

		weapon.attack(dir)

	if (sliding == true and is_on_floor() == false):
		WALK_MAX_SPEED += 400

	if (sliding == true and is_on_floor() == true):
		sliding_time += delta
		WALK_MAX_SPEED += 200


	if (slide == true and sliding == false and not is_on_floor()):
		sliding = true

		if (dir == "left"):
			velocity.x -= WALK_FORCE * 1
		elif (dir == "right"):
			velocity.x += WALK_FORCE * 1

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

			if (sliding == false):
				force.x -= WALK_FORCE

			stop = false

			if (serious_anim.is_playing() == false and sliding == true):
				rotation_degrees = -90

	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:

			anim.flip_h = false
			dir = "right"

			if (sliding == false):
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

		if (sliding == false):
			vlen -= STOP_FORCE * delta
		elif (sliding == true):
			vlen -= STOP_FORCE * delta * SLIDE_FACTOR

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

		if not sliding:

			climb_sprite.visible = true
			wall_jump_notify_timer = 0

	if (wall_jump_notify_timer < notify_duration and climb_sprite.visible == true):
		wall_jump_notify_timer += delta

	if (wall_jump_notify_timer > notify_duration and climb_sprite.visible == true):
		climb_sprite.visible = false

	## Wall jump notifier code
	if (dir == "left"):
		climb_sprite.position.x = 4
		climb_sprite.flip_h = false
	elif (dir == "right"):
		climb_sprite.position.x = -4
		climb_sprite.flip_h = true

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
				dir = "right"
				anim.flip_h = false
			elif (dir == "right"):
				velocity.x = -JUMP_SPEED
				dir = "left"
				anim.flip_h = true

		anim.play("jump")

	on_air_time += delta
	on_air_time_wall += delta
	prev_jump_pressed = jump


	#Handle Regular Enemy attack
	if (knockbacked == true and knockback_timer < knockback_duration):
		knockback_timer += delta
		velocity += knockback_vel * 15 * delta

	if (knockbacked == true and knockback_timer > knockback_duration):
		velocity.x = 0
		knockbacked = false


	if (player_hit == true and hit_timer < hit_cooldown_duration):
		hit_timer += delta

	if (player_hit == true and hit_timer > hit_cooldown_duration):
		player_hit = false


	#Collide collision
	var hit_bodies = hitbox.get_overlapping_bodies()

	for body in hit_bodies:
		if (body.name != name):
			check_collided_body(body)

	#Check up
	check_powerups()

	if (player_info.respawn == true):
		respawn()


func default_props():
	WALK_FORCE = 600
	WALK_MIN_SPEED = 10
	WALK_MAX_SPEED = 200
	SLIDING_DURATION = 0.25
	STOP_FORCE = 1300
	SLIDE_FACTOR = 0.8
	JUMP_SPEED = 400
	JUMP_MAX_AIRBORNE_TIME = 0.2
	GRAVITY = 700.0
	SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
	SLIDE_STOP_MIN_TRAVEL = 1.0

func check_weapons():
	if (player_info.has_weapon() == true):
		
		if (weapon != null):
			weapon.queue_free()
			weapon = null
			
		weapon = player_info.get_current_weapon().instance()
		weapon_holder.add_child(weapon)

func check_powerups():

	var power_up = player_info.power_up

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
	position = player_info.spawn_point
	player_info.respawn = false
	velocity = Vector2(0,0)

func check_collided_body(body):

	var node_name = body.name

	if (body.is_in_group("Ice")):
		iced = true
		iced_timer = 0

	if (node_name == "Hazard"):
		respawn()
		take_damage(1)

	if (body.is_in_group("enemy")):
		if (player_hit) == false:

			player_hit = true

			var enemy = body

			if (dir == "right"):
				knockback_vel = Vector2(-enemy.enemy_knockback, 0)
			elif (dir == "left"):
				knockback_vel = Vector2(enemy.enemy_knockback, 0)

			knockbacked = true
			knockback_timer = 0

			hit_timer = 0
			take_damage(1)


	pass


func take_damage(damage):

	var current_health = player_info.health

	var new_health = current_health - damage
	player_info.health = new_health
