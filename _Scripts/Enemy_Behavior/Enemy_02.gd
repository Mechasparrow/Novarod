extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const GRAVITY = 0

onready var anim = get_node("AnimatedSprite")
onready var hitbox = get_node("Hitbox")

var velocity = Vector2(200,0)

var WALK_FORCE
var WALK_MIN_SPEED
var WALK_MAX_SPEED
var STOP_FORCE
var dir
var hit_marker = false

var enemy_knockback = 1000

var ai_movement_timer = 0
var ai_movement_cooldown = 1

var hit = false
var knockback_vel = Vector2(0,0)
var cooldown_duration = 0.5
var cooldown_timer = 0
var knockback_duration = 0.1
var knockback_timer = 0
var knockedback = false

var health = 3

var xp_drop = true
var xp = 6

onready var xp_pickup = preload("res://_Prefab/Pickups/XP_Pickup.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	WALK_FORCE = 600
	WALK_MIN_SPEED = 10
	WALK_MAX_SPEED = 200
	STOP_FORCE = 1300

	dir = "left"

	pass

func _physics_process(delta):

	var force = Vector2(0, GRAVITY)

	var stop = true

	var walk_left
	var walk_right

	ai_movement_timer += delta

	if (ai_movement_timer > ai_movement_cooldown):
		var random_range = rand_range(0,1)
		WALK_MAX_SPEED = rand_range(200, 1000)
		if (random_range <= 0.5):
			dir = "left"
		else:
			dir = "right"

		ai_movement_timer = 0

	if (dir == "left"):
		walk_left = true
		walk_right = false
	elif (dir == "right"):
		walk_left = false
		walk_right = true

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

	velocity += force * delta
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))

	if (velocity == Vector2(0,0)):
		anim.stop()
		if (anim.is_playing() == false):
			anim.play("still")

	var areas = hitbox.get_overlapping_areas()
	var bodies = hitbox.get_overlapping_bodies()

	if (len(areas) == 0):
		hit_marker = false

	for body in bodies:
		if body.name == "Hazard":
			die()

	# HIT COOLDOWN
	if (hit == true and cooldown_timer < cooldown_duration):

		cooldown_timer += delta

	if (knockedback == true and knockback_timer < knockback_duration):
		velocity += knockback_vel * 15 *  delta
		knockback_timer += delta

	if (knockedback == true and knockback_timer > knockback_duration):
		velocity.x = 0
		knockedback = false

	if (hit == true and cooldown_timer > cooldown_duration):
		hit = false

	#KNOCKBACK

	for body in bodies:

		if (body.is_in_group("bullet")):

			if (hit == false):
				handle_attack(body)
				cooldown_timer = 0
				hit = true
				knockback_timer = 0
				knockedback = true

		pass

	for area in areas:
		var hit_a_marker = false

		if (area.is_in_group("weapon")):

			if (hit == false):
				handle_attack(area)
				cooldown_timer = 0
				hit = true
				knockback_timer = 0
				knockedback = true

		if (area.is_in_group("enemy_marker")):
			hit_a_marker = true

			if (hit_marker == false):
				hit_marker = true
				if (dir == "left"):
					ai_movement_timer = 0
					WALK_MAX_SPEED = 200
					dir = "right"
				elif (dir == "right"):
					position.x -= 30
					ai_movement_timer = 0
					WALK_MAX_SPEED = 200
					dir = "left"

		hit_marker = hit_a_marker

	#check health
	display_health(health)

	if health <= 0:
		die()

	pass

func die():

	## Spawn Drops

	for x in range(xp):
		var xp_pickup_node = xp_pickup.instance()
		get_tree().get_root().get_node("World").add_child(xp_pickup_node)
		xp_pickup_node.global_position = global_position
		xp_pickup_node.scale = Vector2(1,1)

	## End Code


	queue_free()

func handle_attack(weapon):
	var dir = weapon.attack_dir
	var knockback = weapon.knockback_factor

	if (dir == "left"):
		knockback_vel = Vector2(-knockback, 0)
	elif (dir == "right"):
		knockback_vel = Vector2(knockback, 0)

	health -= 1

	print (str(knockback))
	print (str(dir))
	print ("HIT")

func display_health(health):

	var health_display = get_node("Hearts")

	var hearts = health_display.get_children()

	var cnt = 0
	for heart in hearts:
		cnt += 1

		if (cnt > health):
			heart.hide()
		else:
			heart.show()

	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
