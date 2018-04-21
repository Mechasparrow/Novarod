extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var powerup = get_node("Powerup").get_children()[0].name


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	print (powerup)
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

onready var anim = get_node("AnimatedSprite")

func on_body_enter( body ):
	
	if (body.name == "Player"):
		anim.animation = "Open"
		print ("recieved powerup!")
		print ("powerup")
		get_node("/root/playerinfo").power_up = powerup
		return


func on_body_exit( body ):

	if (body.name == "Player"):
		anim.animation = "Close"
		return
