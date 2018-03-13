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

	var enemies_killed = false

	var enemies = get_tree().get_nodes_in_group("enemy")

	if (len(enemies) <= 0):
		enemies_killed = true
	else:
		enemies_killed = false

	if (enemies_killed == true):
		unlocked_img.show()
		locked_img.hide()
	elif (enemies_killed == false):
		unlocked_img.hide()
		locked_img.show()

	pass
