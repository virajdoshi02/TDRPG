extends Node2D

class_name Spell

@export var velocity: Vector2

@onready var lifetime: float

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("Type","Spell")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func move_spell(delta):
	transform.origin+=velocity*delta
	lifetime-=delta
	if lifetime<=0:
		queue_free()
