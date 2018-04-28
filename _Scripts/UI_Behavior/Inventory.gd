extends Node2D

# Code the displays the equiped weapon on the UI

# Get the weapon item slot
onready var WeaponItemSlot = get_node("WeaponItem")

# Player one player props
onready var player_props = get_node("/root/playerinfo")


var current_weapon = null

# Checks if the player has a weapon
# if so, display the weapon in the weapon item slot
# if not, display nothing in the weapon item slot

func _process(delta):
	
	if (player_props.has_weapon()):
		current_weapon = player_props.get_current_weapon().instance()
		WeaponItemSlot.texture = current_weapon.get_node("Sprite").texture

	else:
		WeaponItemSlot.texture = null
		if (current_weapon != null):
			current_weapon.queue_free()
			current_weapon = null
	
