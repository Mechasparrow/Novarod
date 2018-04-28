extends Area2D

# Main script used for NPC Behavior

# Variable for player collision
var player_collide = false

func _process(delta):
	
	# Get the colliding bodies
	var bodies = get_overlapping_bodies()
	
	player_collide = false
	
	# If the NPC collides with the player
	# Pop up the NPC dialogue
	
	for body in bodies:
		
		if (body.name == "Player"):
			player_collide = true
	
	# Shows or hides the dialogue popup
	if (player_collide == true):
		get_node("CanvasLayer/Popup").popup()
	elif (player_collide == false):
		get_node("CanvasLayer/Popup").hide()
