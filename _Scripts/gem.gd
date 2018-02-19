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
	
	for body in bodies:
		print (body.name)
		if (body.name == "Player" and collected == false):
			collected = true
			get_node("/root/playerinfo").gems.append(name)
			hide()
			
	pass

func _process(delta):
	
	if (collected == false):
		show()
	
	pass