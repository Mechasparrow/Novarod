extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func display_health(health):
	
	var hearts = get_children()
	print (len(hearts))
	
	var cnt = 0
	for heart in hearts:
		cnt += 1
		
		if (cnt > health):
			heart.hide()
		else:
			heart.show()
		
		
	
	pass

#func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
#	pass

func on_player_health_changed(health):
	display_health(health)