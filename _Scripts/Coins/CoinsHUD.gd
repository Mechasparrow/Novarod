extends Node2D

func _process(delta):

	# Get the coins that the player has collected
	# Updates the corresponding coin so that the player know how many coins they have
	
	var player_coins = get_node("/root/playerinfo").coins
	
	var coins_label = get_node("Label")
	
	var coins_display_text = "Coins: " + str(player_coins)
	
	coins_label.text = coins_display_text
