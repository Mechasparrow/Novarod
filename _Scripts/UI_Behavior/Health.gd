extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var player_string = "player_one"

var player_info

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	if (player_string == "player_one"):
		player_info = get_node("/root/playerinfo")

	pass


func _process(delta):

	var current_health = player_info.health

	display_health(current_health)

func display_health(health):

	print (health)

	var max_health = player_info.max_health

	get_node("TextureProgress").value = (100/max_health)*health
	pass

#func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
#	pass

func on_player_health_changed(health):
	display_health(health)
