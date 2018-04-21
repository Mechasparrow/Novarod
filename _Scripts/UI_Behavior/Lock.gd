extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var player_info = get_node("/root/playerinfo")

onready var locked_img = get_node("Locked")
onready var unlocked_img = get_node("Unlocked")


var test_passed = false

var gems_collected = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	
	var world = get_tree().get_root().get_node("World")
	
	if (world.is_in_group("gem_collect_level")):
		test_passed = gems_collected()
	elif (world.is_in_group("enemy_kill_level")):
		test_passed = enemies_killed()
	elif (world.is_in_group("coin_collect_level")):
		test_passed = coins_collected()
	else:
		test_passed = true
	
		
	if (test_passed == true):
		unlocked_img.show()
		locked_img.hide()
	elif (test_passed == false):
		unlocked_img.hide()
		locked_img.show()
	
	pass
	
func gems_collected():
	var collected_gems = player_info.gems
	var gem_amnt = len(get_tree().get_nodes_in_group("gem"))
	return len(collected_gems) >= gem_amnt

func enemies_killed():
	var enemies_killed = false

	var enemies = get_tree().get_nodes_in_group("enemy")

	return len(enemies) <= 0

func coins_collected():

	var coins = get_tree().get_nodes_in_group("reg_coin")
	return len(coins) <= 0

