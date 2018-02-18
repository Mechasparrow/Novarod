extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var collected = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	set_physics_process(true)
	pass

func _physics_process(delta):
	
	var bodies = get_overlapping_bodies()
	
	var player_info = get_node("/root/playerinfo")
	
	for body in bodies:
		if body.name == "Player" and collected == false:
			player_info.coins += 1
			hide()
			collected = true

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
