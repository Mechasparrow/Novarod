extends Node

# Player Properties that are accessed by other nodes

var health
var max_health
var coins
var coins_r
var level
var power_up

var timer
var respawn
var spawn_point
var gems

var current_weapon

var max_xp
var xp
var lvl

# Check if the player has a weapon
func has_weapon():
	if get_current_weapon() == null:
		return false
	else:
		return true

# Get the current weapon object
func get_current_weapon():
	return current_weapon

# Set the current weapon object
func set_current_weapon(weapon):
	current_weapon = weapon

# Set the player respawn point
func set_checkpoint(pos):
	spawn_point = pos

# Reset all the player properties
func reset_player_info():
	
	max_health = 3
	health = max_health
	coins = 0
	coins_r = 0
	level = 0
	gems = []
	max_xp = 5
	xp = 0
	lvl = 0
	power_up = null
	current_weapon = null
	timer = 0
	respawn = false
	spawn_point = Vector2(0,0)
