extends Area2D

# Retrieves related door animation
onready var anim = get_node("AnimatedSprite")
onready var lock_anim = get_node("DoorLock")
onready var button_anim = get_node("Button_Hint")

# Boolean variables for whether the door is locked and the player is at the door
var locked = true
var player_here = false

# Returns the locked boolean
func is_locked():
	return locked

# Runs animations corresponding to when the door is opened by the player
func open_door():
	anim.play("Open")
	button_anim.show()
	button_anim.play("default")
	pass

# Runs the animations that signify that the door is unlocked
# Changes locked to false
func unlock_door():
	locked = false
	lock_anim.play("Unlocked")
	pass
	
# Runs the animations the signify that the door is locked
# Changes locked to true
func lock_door():
	locked = true
	lock_anim.play("Locked")
	pass

# Plays the animations corresponding to when the door is closed
func close_door():
	anim.play("Close")
	button_anim.hide()
	pass

func _process(delta):

	var bodies = get_overlapping_bodies()
	
	#By default the player is not at the door	
	player_here = false

	# Run through all the colliders and see if one of them is the player
	# if so then the player is there
	for body in bodies:
		if (body.name == "Player"):
			player_here = true
			

	pass
