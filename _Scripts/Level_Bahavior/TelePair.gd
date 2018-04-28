extends Node2D

# Script that handles the teleportion prefab

#first teleporter
onready var tele_one = get_node("TeleporterOne")

# Second
onready var tele_two = get_node("TeleporterTwo")

func _process(delta):

	var tele_bodies = []

	## Check if something collided with first teleporter
	tele_bodies = tele_one.get_overlapping_bodies()
	
	# If the player collides w/ first, teleport to second
	for body in tele_bodies:
		if (body.is_in_group("player")):
			teleport(body, "two")
			
	## Check if something collided with second teleporter
	tele_bodies = tele_two.get_overlapping_bodies()
	
	## If player collides w/ second, teleport to first
	for body in tele_bodies:
		if (body.is_in_group("player")):
			teleport(body, "one")
	
			

	pass
	
func teleport(object, teleporter):

	# Will either teleport to the 1st or 2nd teleporter with
	# corresponding offset to prevent infinite teleportation
		
	if (teleporter == "one"):
		object.global_position = tele_one.global_position
		object.position.y -= 50
		object.position.x += 100
	elif (teleporter == "two"):
		object.global_position = tele_two.global_position
		object.position.y -= 50
		object.position.x -= 100
	pass	
