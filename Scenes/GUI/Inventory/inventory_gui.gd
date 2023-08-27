extends Control

@onready var inventory:Inventory = preload("res://Scenes/GUI/Inventory/playerInventory.tres")
@onready var slots = $NinePatchRect/GridContainer.get_children()

func contains(item: InventoryItem):
	return item in inventory.items

func add(item:InventoryItem):
	for i in range(inventory.items.size()):
		if inventory.items[i]== null:
			inventory.items[i] = item
			update()
			return true
	return false

func remove(item:InventoryItem):
	if item == null:
		return false
	for i in range(inventory.items.size()):
		if item.equals(inventory.items[i]):
			inventory.items[i] = null
			update()
			return true
	return false

func update():
	for i in range(slots.size()):
		slots[i].update(inventory.items[i])

func open():
	visible = true
	
func close():
	visible = false

func _ready():
	update()
