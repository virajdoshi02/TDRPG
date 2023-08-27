extends AnimatableBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var col = move_and_collide(get_parent().velocity*delta, true)
	if col != null:
		if col.get_collider().get_meta("Type") == "TileMap":
			get_parent().queue_free()
