extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _process(delta):
	
	var current_health = get_node("/root/playerinfo").health
	
	display_health(current_health)

func display_health(health):
	
	print (health)

	var max_health = get_node("/root/playerinfo").max_health

	get_node("TextureProgress").value = (100/max_health)*health
	pass

#func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
#	pass

func on_player_health_changed(health):
	display_health(health)