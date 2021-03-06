extends Node

# Singleton script that stores all the level navigation data 
# This makes navigating between levels easier

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
		"count": 4,
		"1": "Water_01",
		"2": "Water_02",
		"3": "Water_03",
		"4": "Water_Final"
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
	"yellow": {
		"folder": "Airlands",
		"count": 4,
		"1": "Yellow_01",
		"2": "Yellow_02",
		"3": "Yellow_03",
		"4": "Yellow_Final"
	},
	"sandbox": {
		"folder": "Sandbox",
		"count": 0,
		"0": "Level_0"	
	},
	"village": {
		"folder": "Village",
		"count": 2,
		"1": "Village_beginning",
		"2": "Village_ending"
	},
	"endings": {
		"folder": "Navigation",
		"count": 2,
		"1": "Good_Ending",
		"2": "Bad_Ending"	
	}
}

# Using the above level data variable we can generate a path to the level requested
# We can request level paths by the level's type (i.e green, red, etc) and level #
# Returns a scene object

func generate_level_path(type, level):
	
	var level_count = levels[type]["count"]
	
	if (level > level_count):
		var level_select = load("res://_Scenes/Navigation/Level_Select.tscn")
		return level_select
	else:
		var level_path = "res://_Scenes/" + levels[type]["folder"] + "/" + levels[type][str(level)] + ".tscn"
		print (level_path)
		var lvl_scene = load(level_path)
		return lvl_scene
