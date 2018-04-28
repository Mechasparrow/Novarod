extends Area2D

# Script for collectible
# This collectible is the gems

# Boolean for if the gem has been collected
var collected = false

# Make sure the physics loop is enabled
func _ready():

	set_physics_process(true)
	
	pass

# Checks if the player has collided with the gem
# If so and the gem has not been collected
# Set the player respawn to the gem location
# Add the gem to the collected gem list of the player_info variable
# Hide the gem
func _physics_process(delta):
	
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		print (body.name)
		if (body.name == "Player" and collected == false):
			collected = true
			get_node("/root/playerinfo").set_checkpoint(position)
			get_node("/root/playerinfo").gems.append(name)
			hide()
			
	pass

# Checks if the gem has been collected
# if not, show the gem

func _process(delta):
	
	if (collected == false):
		show()
	
	pass