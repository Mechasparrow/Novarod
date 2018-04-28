extends Node

# Creates a global weapons variable that contains the weapon and sword objects
# Used by the weapon_pickup system and the player combat system

# Weapons array
var weapons = []

func _ready():

	var sword = load("res://_Prefab/Weapons/Sword.tscn")
	weapons.append(sword)

	var gun = load("res://_Prefab/Weapons/Player_Gun.tscn")
	weapons.append(gun)

	pass