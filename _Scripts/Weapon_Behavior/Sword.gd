extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var knockback_factor = 2000
var attack_dir = null
var attacking = false

var offset = 5
var damage = 1

onready var anim = get_node("AnimationPlayer")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	pass

func is_attacking():
	return attacking

func attack(dir):
	if not attacking:

		attack_dir = dir

		if (dir == "left"):
			anim.play("Swing_L")
		elif (dir == "right"):
			anim.play("Swing_R")

		attacking = true

func update_orientation(dir):


	pass

func _process(delta):


	if (attacking == true and not (anim.current_animation == "Swing_R" or anim.current_animation == "Swing_L")):
		attacking = false

	if (attacking == true):
		get_node("Hitbox").disabled = false
	elif (attacking == false):
		get_node("Hitbox").disabled = true
