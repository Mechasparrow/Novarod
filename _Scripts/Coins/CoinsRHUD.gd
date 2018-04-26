extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):

	# SAME as CoinsHUD.gd
	# Displays the amnt of red coins the player has collected

	var player_r_coins = get_node("/root/playerinfo").coins_r

	var coins_label = get_node("Label")

	var coins_display_text = "R: " + str(player_r_coins)

	coins_label.text = coins_display_text
