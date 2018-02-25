extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var anim = get_node("AnimatedSprite")
var player_here = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func open_door():
	anim.play("Open")
	pass

func close_door():
	anim.play("Close")
	pass

func _process(delta):


	var bodies = get_overlapping_bodies()
	
	player_here = false

	for body in bodies:
		if (body.name == "Player"):
			player_here = true
			

	pass
