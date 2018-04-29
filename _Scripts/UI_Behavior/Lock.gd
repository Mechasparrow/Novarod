extends Node2D

# Script in charge of handling the lock display on the UI

# Player Info
onready var player_info = get_node("/root/playerinfo")

# Locked and unlocked images
onready var locked_img = get_node("Locked")
onready var unlocked_img = get_node("Unlocked")

# Did the player pass the level challenge
var test_passed = false

# Checks if the player has completed the objective
# If so, display the unlocked image 
# If not, display the locked image
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

