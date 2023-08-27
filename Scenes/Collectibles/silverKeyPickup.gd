extends Collectible

@export var key:InventoryItem

func collect(player:Player):
	if player.give(key):
		super(player)

# Called when the node enters the scene tree for the first time.
func _ready():
	super() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
