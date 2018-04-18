extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var anim = get_node("AnimationPlayer")
onready var animated_sprite = get_node("AnimatedSprite")
onready var hitbox = get_node("Hitbox")

var velocity = Vector2(0,0)

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

var health = 7

var xp_drop = true
var xp = 6

# Projectile Prefab

onready var lightningball = preload("res://_Prefab/Projectiles/Lightning_Ball.tscn")
var lightningball_offset = 100

# Shooting Mechanism
var shoot_timer = 0
var shoot_cooldown = 1
var shoot_cooldown_max = 1
var can_shoot = false

var shoot_dir = "left"
var shoot_speed = 600

onready var xp_pickup = preload("res://_Prefab/Pickups/XP_Pickup.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	anim.play("Moving")

	pass

func _physics_process(delta):


	# Shooting AI

	if (animated_sprite.flip_h == false):
		shoot_dir = "right"
	elif (animated_sprite.flip_h == true):
		shoot_dir = "left"

	if (can_shoot == false and shoot_timer < shoot_cooldown):
		shoot_timer+= delta
	elif (can_shoot == false and shoot_timer >= shoot_cooldown):
		can_shoot = true

	if (can_shoot):
		var new_lightningball = lightningball.instance()
		new_lightningball.global_position = global_position

		# Adds an offset so it is not on top of player_gun
		if (shoot_dir == "left"):
			new_lightningball.position.x -= lightningball_offset
		elif (shoot_dir == "right"):
			new_lightningball.position.x += lightningball_offset

		get_tree().get_root().get_node("World").add_child(new_lightningball)

		new_lightningball.shoot(shoot_dir, shoot_speed)

		can_shoot = false
		shoot_timer = 0

	# Shooting AI End

	


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
