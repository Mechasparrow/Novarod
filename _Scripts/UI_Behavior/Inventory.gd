extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var WeaponItemSlot = get_node("WeaponItem")
onready var player_props = get_node("/root/playerinfo")

var current_weapon = null


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	
	pass

func _process(delta):
	
	if (player_props.has_weapon()):
		current_weapon = player_props.get_current_weapon().instance()
		WeaponItemSlot.texture = current_weapon.get_node("Sprite").texture

	else:
		WeaponItemSlot.texture = null
		if (current_weapon != null):
			current_weapon.queue_free()
			current_weapon = null		


	pass
	
	
