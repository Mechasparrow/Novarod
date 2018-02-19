extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var win_popup = get_node("HUD/Win_Pop_Up")
onready var win_popup_time = get_node("HUD/Win_Pop_Up/Time_Stop")

var level_end = false

export var reset_position = Vector2(100,400)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	get_node("/root/playerinfo").reset_player_info()
	get_node("/root/playerinfo").spawn_point = reset_position
	
	pass

func _process(delta):

	var current_time = get_node("/root/playerinfo").timer

	var reset_button_hit = Input.is_action_pressed("reset_button")

	var collected_gems = get_node("/root/playerinfo").gems
	var gem_amnt = get_node("/root/playerinfo").gem_amnt

	if (len(collected_gems) >= gem_amnt and level_end == false):
		level_end = true
		level_stop()

	if (reset_button_hit):
		current_time = 0
		get_node("/root/playerinfo").reset_player_info()
		get_tree().reload_current_scene()

	if (level_end == false): 
		current_time+= delta
		get_node("/root/playerinfo").timer = current_time
	else:
		print ("LEVEL END")

	pass


func level_stop():
	win_popup.popup()	
	level_end = true
	
	var current_time = get_node("/root/playerinfo").timer
	
	win_popup_time.text = "You ended at %.2f" % current_time 
	
