extends Interactable

@onready var light = $Area2D/Sprite2D/Light

func interact(area:Area2D):
	if area.get_parent().get_meta("Element")=="Fire":
		light.visible = true
		get_parent().removeWall(global_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	super() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
