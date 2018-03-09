extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var animator = get_node("AnimationPlayer")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	animator.play("Bobin")


	pass

func _process(delta):

	var bodies = get_overlapping_bodies()
	var areas =get_overlapping_areas()

	var colliders = bodies + areas

	for collider in colliders:
		if (collider.is_in_group("player")):
			print ("XP BABY")
			var player = collider
			var player_props = collider.player_info
			player_props.xp += 1
			queue_free()
			pass

	pass


