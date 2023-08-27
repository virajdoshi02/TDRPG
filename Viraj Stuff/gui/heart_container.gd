extends HBoxContainer

@onready var HeartGui = preload("res://Viraj Stuff/gui/heart.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setMaxHearts(max):
	for i in range(max):
		var heart = HeartGui.instantiate()
		add_child(heart)
