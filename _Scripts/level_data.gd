extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var levels = {
	"green": {
		"folder": "Grasslands",
		"count": 4,
		"1": "Green_01",
		"2": "Green_02",
		"3": "Green_03",
		"4": "Green_Final"
	},
	"blue": {
		"folder": "Waterlands",
		"count": 2,
		"1": "Water_01",
		"2": "Water_02"
	},
	"tutorial": {
		"folder": "Tutorials",
		"count": 6,
		"1": "Tutorial_01",
		"2": "Tutorial_02",
		"3": "Tutorial_03",
		"4": "Tutorial_04",
		"5": "Tutorial_05",
		"6": "Tutorial_06"
	},
	"red": {
		"folder": "Firelands",
		"count": 4,
		"1": "Red_01",
		"2": "Red_02",
		"3": "Red_03",
		"4": "Red_Final"
	},
	"sandbox": {
		"folder": "Sandbox",
		"count": 0,
		"0": "Level_0"	
	}
}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func generate_level_path(type, level):
	
	var level_count = levels[type]["count"]
	
	if (level > level_count):
		var level_select = load("res://_Scenes/Level_Select.tscn")
		return level_select
	else:
		var lvl_scene = load("res://_Scenes/" + levels[type]["folder"] + "/" + levels[type][str(level)] + ".tscn")
		return lvl_scene
