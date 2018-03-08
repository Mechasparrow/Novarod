extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var attacking = false
var attacking_duration = 0.2
var attacking_timer = 0

var offset = 7

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	pass

func is_attacking():
	return attacking

func attack(dir):

	attacking = true
	attacking_timer = 0

	if (dir == "left"):
		get_node("Sprite").flip_h = true
	elif (dir == "right"):
		get_node("Sprite").flip_h = false

	## TODO Add projectile spawning here!



	##

func update_orientation(dir):

	if (dir == "left"):
		get_node("Sprite").flip_h = true
	elif (dir == "right"):
		get_node("Sprite").flip_h = false

func _process(delta):

	if (attacking == true):
		show()
	elif (attacking == false):
		hide()


	if (attacking_timer < attacking_duration and attacking == true):
		attacking_timer+=delta
	elif (attacking_timer > attacking_duration and attacking == true):
		attacking = false

	pass
