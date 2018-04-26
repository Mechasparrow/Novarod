extends RigidBody2D

# Script in charge of handling interaction with the first grasslands boss

onready var player_props = get_node("/root/playerinfo")

var cage_opened = false

onready var golden_carrot = preload("res://_Prefab/Projectiles/Golden_Carrot_Projectile.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):

	# Checks if the player has collected all the gems
	# if so it will open the cage containing the golden carrot
	
	var collected = gems_collected()

	if (collected == true and cage_opened == false):
		open_cage()

	pass

# Opens the cage that contains the golden carrot

func open_cage():
	print ("OPEN CAGE")
	queue_free()
	spawn_carrot()
	cage_opened = true

# Spawns a golden carrot that can destroy the boss in one hit
	
func spawn_carrot():
	
	
	
	var world = get_tree().get_root().get_node("World")
	var old_carrot = world.get_node("Killer_Carrot")
	
	old_carrot.queue_free()
	
	var new_carrot = golden_carrot.instance()
	
	new_carrot.global_position = global_position
	world.add_child(new_carrot)
	
# Checks if all the gems have been collected by the player
func gems_collected():
	
	var collected_gems = player_props.gems
	
	
	var gem_amnt = len(get_tree().get_nodes_in_group("gem"))
	
	var gems_collected = len(collected_gems) >= gem_amnt
	
	return gems_collected
