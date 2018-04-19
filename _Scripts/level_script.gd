extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var win_popup = get_node("HUD/Win_Pop_Up")
onready var win_popup_time = get_node("HUD/Win_Pop_Up/Time_Stop")
onready var end_door = get_node("Door")
onready var level_info = get_node("level_info")

var level_complete = false

var level_end = false
var lost = false

export var reset_position = Vector2(100,400)

onready var level_menu_scene = preload("res://_Scenes/Level_Select.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	get_node("/root/playerinfo").spawn_point = reset_position
	
	pass

func _process(delta):

	if (Input.is_action_pressed("escape")):
		get_tree().change_scene_to(level_menu_scene)

	var current_time = get_node("/root/playerinfo").timer
	var current_health = get_node("/root/playerinfo").health

	var reset_button_hit = Input.is_action_pressed("reset_button")
	var next_level = Input.is_action_pressed("jump")

	if (is_in_group("gem_collect_level")):
		level_complete = gem_collect_level_complete()
	elif (is_in_group("enemy_kill_level")):
		level_complete = kill_enemy_level_complete()
	elif (is_in_group("coin_collect_level")):
		level_complete = collect_coins_complete()	
	else:
		level_complete = true

	var enter_door = Input.is_action_pressed("interact")

	if (current_health <= 0):
		lost = true
		
	if (level_complete):
		end_door.unlock_door()
		
	if (level_complete and end_door.player_here):
		end_door.open_door()
	else:
		end_door.close_door()

	if (level_complete and end_door.player_here == true and level_end == false and enter_door):
		level_end = true
		level_stop()
		

	if (reset_button_hit):
		lost = true
		
	if (level_end == true and next_level == true):
		var type = level_info.type
		var current_level = level_info.level
		
		if (type == "village" and current_level == 1):
			type = "green"
			current_level = 0
		
		var nxt_level = current_level + 1

		var level_scn = get_node("/root/level_data").generate_level_path(type, nxt_level)
		get_tree().change_scene_to(level_scn)


	if (level_end == false): 
		current_time+= delta
		get_node("/root/playerinfo").timer = current_time
	else:
		print ("LEVEL END")

	if (lost == true):
		current_time = 0
		get_node("/root/playerinfo").reset_player_info()
		get_tree().reload_current_scene()


func level_stop():
	win_popup.popup()	
	level_end = true
	
	var current_time = get_node("/root/playerinfo").timer
	
	win_popup_time.text = "You ended at %.2f" % current_time 
	
func gem_collect_level_complete():
	var collected_gems = get_node("/root/playerinfo").gems
	
	
	var gem_amnt = len(get_tree().get_nodes_in_group("gem"))
	
	var gems_collected = len(collected_gems) >= gem_amnt
	
	return gems_collected
	
func kill_enemy_level_complete():
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	return len(enemies) <= 0
	
func collect_coins_complete():
	var coins = get_tree().get_nodes_in_group("reg_coin")
	
	return len(coins) <= 0