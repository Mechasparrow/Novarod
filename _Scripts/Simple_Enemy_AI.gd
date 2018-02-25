extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const GRAVITY = 700.0

onready var anim = get_node("AnimatedSprite")
onready var hitbox = get_node("Hitbox")

var velocity = Vector2(0,0)

var WALK_FORCE
var WALK_MIN_SPEED
var WALK_MAX_SPEED
var STOP_FORCE
var dir
var hit_marker = false

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
		if (anim.is_playing() == false or anim.animation == "still" and is_on_floor()):
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
	
	if (len(areas) == 0):
		hit_marker = false
	
	for area in areas:
		var hit_a_marker = false
		
		if (area.is_in_group("enemy_marker")):
			hit_a_marker = true
			
			if (hit_marker == false):
				hit_marker = true
				if (dir == "left"):
					dir = "right"
				elif (dir == "right"):
					dir = "left"
					
		hit_marker = hit_a_marker
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
