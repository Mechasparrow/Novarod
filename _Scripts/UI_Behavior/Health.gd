extends Node2D

# Code that handles displaying player health on the UI

# Variables relating to the player
var player_string = "player_one"

var player_info

# Checks which player health to display
# corresponding player info global variable

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	if (player_string == "player_one"):
		player_info = get_node("/root/playerinfo")

	pass


# Gets the current player health
# Displays the health

func _process(delta):

	var current_health = player_info.health

	display_health(current_health)

# Main health display function
func display_health(health):

	print (health)

	# Get the player max health
	var max_health = player_info.max_health

	# Renders the health % on a progress bar
	get_node("TextureProgress").value = (100/max_health)*health
	pass