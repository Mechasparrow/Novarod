extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var player_info = get_node("/root/playerinfo")

onready var locked_img = get_node("Locked")
onready var unlocked_img = get_node("Unlocked")


var gems_collected = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	
	var collected_gems = player_info.gems
	
	if (len(collected_gems) >= player_info.gem_amnt):
		gems_collected = true
	else:
		gems_collected = false
		
	if (gems_collected == true):
		unlocked_img.show()
		locked_img.hide()
	elif (gems_collected == false):
		unlocked_img.hide()
		locked_img.show()
	
	pass
