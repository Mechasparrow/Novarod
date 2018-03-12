extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var player_info = get_node("/root/playerinfo")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _process(delta):

	var current_xp = player_info.xp

	display_xp(current_xp)

func display_xp(xp):

	var max_xp = player_info.max_xp

	if (xp >= max_xp):
		player_info.xp = 0
		player_info.lvl += 1
	
	
	get_node("TextureProgress").value = (100/max_xp)*xp
	get_node("Level").text = str(player_info.lvl)

	
	pass

#func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
#	pass