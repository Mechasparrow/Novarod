extends Node2D

# Displays the current equiped powerup to the HUD (UI)

# Gets the powerup from the player_info and writes the name of it to a UI Label
func _process(delta):
		
	var power_up_label = get_node("Label")
	var current_power_up = get_node("/root/playerinfo").power_up
	
	if (str(current_power_up) == "Null"):
		current_power_up = "None"
	
	power_up_label.text = "Powerup: " + str(current_power_up)

