extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var tele_one = get_node("TeleporterOne")
onready var tele_two = get_node("TeleporterTwo")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):

	var tele_bodies = []

	## Check if something collided with first teleporter
	tele_bodies = tele_one.get_overlapping_bodies()
	
	for body in tele_bodies:
		if (body.is_in_group("player")):
			teleport(body, "two")
			
	## Check if something collided with second teleporter
	tele_bodies = tele_two.get_overlapping_bodies()
	
	for body in tele_bodies:
		if (body.is_in_group("player")):
			teleport(body, "one")
	
			

	pass
	
func teleport(object, teleporter):
	
	if (teleporter == "one"):
		object.global_position = tele_one.global_position
		object.position.y -= 50
		object.position.x += 100
	elif (teleporter == "two"):
		object.global_position = tele_two.global_position
		object.position.y -= 50
		object.position.x -= 100
	pass	
