extends Node

var health
var coins
var coins_r
var level
var gem_amnt
var power_up

var timer
var respawn
var spawn_point
var gems

func set_checkpoint(pos):
	spawn_point = pos

func reset_player_info():
	
	health = 3
	coins = 0
	coins_r = 0
	level = 0
	gems = []
	gem_amnt = 4
	power_up = null
	
	timer = 0
	respawn = false
	spawn_point = Vector2(0,0)