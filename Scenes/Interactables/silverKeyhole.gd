extends Interactable

@export var key:InventoryItem

func interact(area:Area2D):
	if area.get_parent().get_meta("Type")=="Weapon":
		var player = area.get_parent().get_parent()
		if player.take(key):
			get_parent().removeWall(global_position, true)

# Called when the node enters the scene tree for the first time.
func _ready():
	super() # Replace with function body.

