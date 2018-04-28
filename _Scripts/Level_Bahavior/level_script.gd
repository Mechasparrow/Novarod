extends Node

# Script attached to the world node
# Used for checking level completion
# Whether the player has completed the objective (gem collection, enemy killing, coin collection)
# Whether the player is dead

# Popups regarding when the player completes the level
onready var win_popup = get_node("HUD/Win_Pop_Up")
onready var win_popup_time = get_node("HUD/Win_Pop_Up/Time_Stop")

# Reference to the door that ends the level when entered
onready var end_door = get_node("Door")

# All level info of current level for navigation
onready var level_info = get_node("level_info")

# Variables for level completion
var level_complete = false
var level_end = false

# Variable checking if the player has died
var lost = false

# Position to reset the player at
export var reset_position = Vector2(100,400)

# Level Selection screen if the player wishs to quit the level
onready var level_menu_scene = preload("res://_Scenes/Navigation/Level_Select.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	# Sets the players spawn point
	get_node("/root/playerinfo").spawn_point = reset_position
	
	pass

func _process(delta):

	# If the player hits escape, send him to level select
	if (Input.is_action_pressed("escape")):
		get_tree().change_scene_to(level_menu_scene)

	# Retrieve the current time since the level has started and the players health
	var current_time = get_node("/root/playerinfo").timer
	var current_health = get_node("/root/playerinfo").health

	var reset_button_hit = Input.is_action_pressed("reset_button")
	var next_level = Input.is_action_pressed("jump")

	# Checks if the player has completed the objectives specified
	
	if (is_in_group("gem_collect_level")):
		level_complete = gem_collect_level_complete()
	elif (is_in_group("enemy_kill_level")):
		level_complete = kill_enemy_level_complete()
	elif (is_in_group("coin_collect_level")):
		level_complete = collect_coins_complete()	
	else:
		level_complete = true

	# See if player is trying to enter door
	var enter_door = Input.is_action_pressed("interact")

	# Did the player lose all his health?
	# Then he lost the level
	if (current_health <= 0):
		lost = true
		
	# If the level is completed unlock the door so the player knows he can open it
	if (level_complete):
		end_door.unlock_door()
		
	# If the player is next to the door, open it for the player to enter and vice versa
	if (level_complete and end_door.player_here):
		end_door.open_door()
	else:
		end_door.close_door()

	# If player has completed the level and enters the door, end the level
	if (level_complete and end_door.player_here == true and level_end == false and enter_door):
		
		# Game Over bypass
		var type = level_info.type
		var current_level = level_info.level
		
		# Special case. If this is the end village, redirect to the good ending
		if (type == "village" and current_level == 2):
			var good_ending = load("res://_Scenes/Navigation/Good_Ending.tscn")
			get_tree().change_scene_to(good_ending)
			
			pass
		
		level_end = true
		level_stop()
		

	# If the reset button is hit, suicide the player
	if (reset_button_hit):
		lost = true
	
	# When the player chooses to go to the next level
	# Redirect to the next level using the level_info variable
	
	if (level_end == true and next_level == true):
		var type = level_info.type
		var current_level = level_info.level
		
		if (type == "village" and current_level == 1):
			type = "green"
			current_level = 0
			
		var nxt_level = current_level + 1

		var level_scn = get_node("/root/level_data").generate_level_path(type, nxt_level)
		get_tree().change_scene_to(level_scn)

	# If the level has not ended, keep track of the time since the level has started
	
	if (level_end == false): 
		current_time+= delta
		get_node("/root/playerinfo").timer = current_time
	else:
		print ("LEVEL END")

	# when the player loses, reset the player_info and reset the scene
	if (lost == true):
		current_time = 0
		get_node("/root/playerinfo").reset_player_info()
		get_tree().reload_current_scene()

# Stops the level when it has been completed
# Stops the timer
# Popups the completion panel
func level_stop():
	win_popup.popup()	
	level_end = true
	
	var current_time = get_node("/root/playerinfo").timer
	
	win_popup_time.text = "You ended at %.2f" % current_time 
	
# Returns whether all the gems in the level have been collected
func gem_collect_level_complete():
	var collected_gems = get_node("/root/playerinfo").gems
	
	
	var gem_amnt = len(get_tree().get_nodes_in_group("gem"))
	
	var gems_collected = len(collected_gems) >= gem_amnt
	
	return gems_collected
	
# Returns if all the enemies have been killed
func kill_enemy_level_complete():
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	return len(enemies) <= 0
	
# Returns if all the coins have been collected
func collect_coins_complete():
	var coins = get_tree().get_nodes_in_group("reg_coin")
	
	return len(coins) <= 0