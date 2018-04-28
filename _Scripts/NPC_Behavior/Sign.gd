extends Area2D

# Very similar to how Birdo.gd functions

# The popup node for the sign dialogue
onready var popup = get_node("CanvasLayer/PopupPanel")

# Checks if player has entered the sign's collision area
# if so, show the dialogue
func on_body_enter( body ):
	
	if (body.name == "Player"):
		popup.popup()

# Checks if player has left the sign's collision area
# if so, hide the dialogue
func on_body_exit( body ):
	
	if (body.name == "Player"):
		popup.hide()