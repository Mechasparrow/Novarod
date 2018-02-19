extends Node

var health = 3
var coins = 0
var level = 0
var power_up = null

var timer = 0
var respawn = false
var spawn_point = Vector2(0,0)

func reset_player_info():
	
	health = 3
	coins = 0
	level = 0
	power_up = null
	
	timer = 0
	respawn = false
	spawn_point = Vector2(0,0)