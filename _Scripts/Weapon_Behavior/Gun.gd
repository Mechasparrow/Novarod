extends Area2D

# Behavior for the gun weapon

# Classic weapon variables for handling attacks
var attacking = false
var attacking_duration = 0.2
var attacking_timer = 0

# Shooting variable
var can_shoot = false
var shoot_timer = 0
var shooting_duration = 0.5

# Projectile offset
var offset = 7

# Projectile
onready var bullet = preload("res://_Prefab/Projectiles/Player_Bullet.tscn")

# Returns whether or not the weapon is being used
func is_attacking():
	return attacking

# Shoots the gun
func attack(dir):

	# Attacking delay to prevent spamming
	attacking = true
	attacking_timer = 0

	if (dir == "left"):
		get_node("Sprite").flip_h = true
	elif (dir == "right"):
		get_node("Sprite").flip_h = false

	## Shoot projectile
	if (can_shoot == true):
		
		var new_bullet = bullet.instance()
		get_tree().get_root().get_node("World").add_child(new_bullet)
		new_bullet.global_position = global_position
		
		# Adds an offset so it is not on top of player_gun
		if (dir == "left"):
			new_bullet.position.x -= 40
		elif (dir == "right"):
			new_bullet.position.x += 40
		
		new_bullet.shoot(dir, 600)
		
		can_shoot = false
		shoot_timer = 0
		
	##

# Update the orientation of the gun
func update_orientation(dir):

	if (dir == "left"):
		get_node("Sprite").flip_h = true
	elif (dir == "right"):
		get_node("Sprite").flip_h = false

# Update the timers for shooting and attacking
# Also whether or not the weapon should be shown
func _process(delta):

	if (attacking == true):
		show()
	elif (attacking == false):
		hide()

	if (can_shoot == false and shoot_timer < shooting_duration):
		shoot_timer += delta

	if (can_shoot == false and shoot_timer > shooting_duration):
		can_shoot = true

	if (attacking_timer < attacking_duration and attacking == true):
		attacking_timer+=delta
	elif (attacking_timer > attacking_duration and attacking == true):
		attacking = false

	pass
