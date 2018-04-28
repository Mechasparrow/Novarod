extends Area2D

# Get the type of powerup
onready var powerup = get_node("Powerup").get_children()[0].name

# Get the Chest Sprite Animation
onready var anim = get_node("AnimatedSprite")

# On a collision with a colliding body
func on_body_enter( body ):
	
	# If the body is the player, give the player the powerup and open the chest
	if (body.name == "Player"):
		anim.animation = "Open"
		print ("recieved powerup!")
		print ("powerup")
		get_node("/root/playerinfo").power_up = powerup
		return

# On when a colliding body leaves the collision area
func on_body_exit( body ):

	# If the player leaves the collision area, close the chest
	if (body.name == "Player"):
		anim.animation = "Close"
		return
