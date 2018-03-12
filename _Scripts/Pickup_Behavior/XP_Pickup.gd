extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var xp_hitbox = get_node("Hitbox")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	pass

func _physics_process(delta):
	var bodies = xp_hitbox.get_overlapping_bodies()
	var areas = xp_hitbox.get_overlapping_areas()

	var colliders = bodies + areas

	for collider in colliders:
		if (collider.is_in_group("player")):
			print ("XP BABY")
			var player = collider
			var player_props = collider.player_info
			player_props.xp += 1
			queue_free()
			pass