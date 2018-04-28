extends KinematicBody2D

# Script that deals with horizontal moving platforms

# Starting speed and direction of platform
var speed = 300
var dir = "left"

# Timer variables for back-and-forth platform motion
var movement_timer = 0
var movement_duration = 2.0

# Hitbox for the platform
onready var platform_hitbox = get_node("Hitbox")

# Each frame update the position of the platform 
# Make it go right/left depending on if the timer run through a cycle
func _process(delta):
	
	# Shift x-pos to left or right depending on platform direction
	
	if (dir == "left"):
		position.x -= speed * delta
		pass
	elif (dir == "right"):
		position.x += speed * delta
		pass
	
	# Update the movement timer
	movement_timer += delta
	
	# If the movement timer has completed a cycle, flip the direction
	# Clear the timer
	
	if (movement_timer > movement_duration):
		if (dir == "left"):
			dir = "right"
			movement_timer = 0
		elif (dir == "right"):
			dir = "left"
			movement_timer = 0
	
	# See if the player has collided with the platform
	# If so append the velocity of the platform to the player and then some
	
	var platform_bodies = platform_hitbox.get_overlapping_bodies()
	
	for body in platform_bodies:
		var body_position = body.position
		
		if (dir == "left"):
			body_position.x -= speed * delta * 1.5
			
		elif (dir == "right"):
			body_position.x += speed * delta * 1.5
	
