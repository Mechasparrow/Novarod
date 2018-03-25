extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var anim = get_node("AnimatedSprite")
onready var lock_anim = get_node("DoorLock")
onready var button_anim = get_node("Button_Hint")

var locked = true
var player_here = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func is_locked():
	return locked

func open_door():
	anim.play("Open")
	button_anim.show()
	button_anim.play("default")
	pass

func unlock_door():
	locked = false
	lock_anim.play("Unlocked")
	pass
func lock_door():
	locked = true
	lock_anim.play("Locked")
	pass

func close_door():
	anim.play("Close")
	button_anim.hide()
	pass

func _process(delta):


	var bodies = get_overlapping_bodies()
	
	player_here = false

	for body in bodies:
		if (body.name == "Player"):
			player_here = true
			

	pass
