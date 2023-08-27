extends CanvasLayer

@onready var inventory = $InventoryGUI

var dialogueBox = preload("res://Scenes/GUI/dialogue_box.tscn")

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		if inventory.visible:
			inventory.close()
		else: 
			inventory.open()
			
func _ready():
	inventory.close()

func createDialogueBox(g:Callable):
	g.call()
	
