extends Resource

class_name InventoryItem

@export var name:String
@export var sprite: Texture2D

func equals(item):
	if item == null:
		return false
	return name == item.name and sprite == item.sprite
