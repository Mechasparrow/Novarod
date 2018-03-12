extends Node

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

func has_weapon():
	if get_current_weapon() == null:
		return false
	else:
		return true

func get_current_weapon():
	return current_weapon

func set_current_weapon(weapon):
	current_weapon = weapon

func set_checkpoint(pos):
	spawn_point = pos

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
