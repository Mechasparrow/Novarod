extends KinematicBody2D

# Script for the enemy behavior of the bunny boss

const GRAVITY = 700.0

# Enemy hitbox and visible animation
onready var anim = get_node("AnimatedSprite")
onready var hitbox = get_node("Hitbox")

#Enemy movement vector
var velocity = Vector2(200,0)

# Variables regulating enemy movement
var WALK_FORCE
var WALK_MIN_SPEED
var WALK_MAX_SPEED
var STOP_FORCE
var dir
var hit_marker = false

# Variables for regulating AI
var ai_movement_timer = 0
var ai_movement_cooldown = 1

# Enemy combat variables
var enemy_knockback = 1000
var hit = false
var knockback_vel = Vector2(0,0)
var cooldown_duration = 0.5
var cooldown_timer = 0
var knockback_duration = 0.1
var knockback_timer = 0
var knockedback = false

var health = 6

# Enemy XP Drop
var xp_drop = true
var xp = 25

onready var xp_pickup = preload("res://_Prefab/Pickups/XP_Pickup.tscn")

# Projectile Prefab

onready var carrot = preload("res://_Prefab/Projectiles/Carrot_Projectile.tscn")
var carrot_offset = 100
var carrot_y_range = 100

# Shooting Mechanism
var shoot_timer = 0
var shoot_cooldown = 1.0
var shoot_cooldown_max = 1.0
var can_shoot = false

var shoot_dir = "left"
var shoot_speed = 600


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	# Enemy properties
	WALK_FORCE = 600
	WALK_MIN_SPEED = 10
	WALK_MAX_SPEED = 200
	STOP_FORCE = 1300

	dir = "left"

	pass

func _physics_process(delta):
	
	var force = Vector2(0, 0)

	var stop = true

	## Enemy AI + Movement
	
	## Shooting Carrots Section
	if (can_shoot == false and shoot_timer < shoot_cooldown):
		shoot_timer+= delta
	elif (can_shoot == false and shoot_timer >= shoot_cooldown):
		can_shoot = true
		
	if (can_shoot):
		var new_carrot = carrot.instance()
		new_carrot.global_position = global_position
		
		var random_dir_value = rand_range(0.0, 1.0)
		# Shoot in random direction
		if (random_dir_value < 0.5):
			shoot_dir = "left"
		elif (random_dir_value >= 0.5):
			shoot_dir = "right"
		
		new_carrot.position.y += (carrot_y_range/2)
		var random_y_pos = rand_range(0.0,1.0)
		var real_y_pos = 0
		
		# Randomize carrot y position
		if (random_y_pos < (1.0/3)):
			real_y_pos = 0
		elif (random_y_pos >= (1.0/3) and random_y_pos <= ((1.0/3)*2)):
			real_y_pos = 1.0/2
		elif (random_y_pos > ((1.0/3)*2) and random_y_pos <= 1.0):
			real_y_pos = 1.0 
		
		new_carrot.position.y -= carrot_y_range * real_y_pos
		
		# Adds an offset so it is not on top of player_gun
		if (shoot_dir == "left"):
			new_carrot.position.x -= carrot_offset
		elif (shoot_dir == "right"):
			new_carrot.position.x += carrot_offset
		
		get_tree().get_root().get_node("World").add_child(new_carrot)
		
		new_carrot.shoot(shoot_dir, 500)
		
		can_shoot = false
		
		# Randomize carrot projectile shoot cooldown
		var cooldown_random_factor = rand_range(0.0, 1.0)
			
		if (cooldown_random_factor <= (1.0/3)):
			cooldown_duration = (1.0/3) * shoot_cooldown_max
		elif (cooldown_random_factor > (1.0/3) and cooldown_random_factor <= ((1.0/3)*2)):
			cooldown_duration = ((1.0/3) * 2) * shoot_cooldown_max
		elif (cooldown_random_factor > ((1.0/3)*2) and cooldown_random_factor <= 1.0):
			cooldown_duration = 1.0 * shoot_cooldown_max
		
		shoot_timer = 0

	
	## Shooting End
	

	velocity += force * delta

	if (velocity == Vector2(0,0)):
		anim.stop()
		if (anim.is_playing() == false):
			anim.play("still")

	# Collision Detection
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

	#KNOCKBACK and Attack handling

	for body in bodies:

		if(body.is_in_group("super_bullet")):
			die()

		if (body.is_in_group("bullet")):

			if (hit == false):
				handle_attack(body)
				cooldown_timer = 0
				hit = true
				knockback_timer = 0
				knockedback = true

		pass

	# Checks if hit by either weapon or enemy-marker
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

	# Kill the enemy if health hits zero
	if health <= 0:
		die()

	pass

# Kill the enemy
func die():

	## Spawn Drops

	for x in range(xp):
		var xp_pickup_node = xp_pickup.instance()
		get_tree().get_root().get_node("World").add_child(xp_pickup_node)
		xp_pickup_node.global_position = global_position
		xp_pickup_node.scale = Vector2(1,1)

	## End Code


	queue_free()

# Handles an attack from a weapon
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

# Displays the health above the enemies head
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

