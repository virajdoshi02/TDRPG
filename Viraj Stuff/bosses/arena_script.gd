extends Area2D

@export var hasEntered:bool
@export var player: CharacterBody2D

@export var tileMap: TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	hasEntered = false
	remove_child(tileMap)
	
func removeWall():
	remove_child(tileMap)
	get_parent().queue_free()

func isPlayer(area)->bool:
	if area.is_inside_tree():
		if area.get_parent().get_meta("Type") == "Player":
			return true
	return false

func _on_entrance_area_entered(area):
	if isPlayer(area):
		hasEntered = true
		player = area.get_parent()
		add_child(tileMap)
