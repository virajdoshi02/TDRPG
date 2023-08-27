extends Area2D

class_name Collectible

func collect(player:Player):
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("Type","Collectible")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
