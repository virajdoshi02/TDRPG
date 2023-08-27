extends Node2D

@onready var heartContainer = $CanvasLayer/HeartContainer
@onready var player = $TileMap/Player

# Called when the node enters the scene tree for the first time.
func _ready():
	heartContainer.setMaxHearts(player.maxHealth)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
