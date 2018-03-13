extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var buttons = get_tree().get_nodes_in_group("select_button")

var levels = {
	"green": {
		"folder": "Grasslands",
		"1": "Green_01"
	},
	"sandbox": {
		"folder": "Sandbox",
		"0": "Level_0"	
	}
}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):

	for button in buttons:
		if (button.is_pressed() == true):
			print ("True")
			var level = button.level
			var type = button.type
			
			var lvl_scene = load("res://_Scenes/" + levels[type]["folder"] + "/" + levels[type][str(level)] + ".tscn")
			get_tree().change_scene_to(lvl_scene)

	pass
