extends Panel

@onready var background = $Sprite2D
@onready var item  = $Item

var timer:float = 0
var maxTime:float

func update(i: InventoryItem):
	if !i:
		background.frame = 0
		item.texture = null
	else:
		background.frame = 1
		item.texture = i.sprite

func activateTimer(time):
	if item.texture == null:
		return
	timer = time
	maxTime = time

func getTimerFinished():
	return not timer>0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer>0:
		item.self_modulate = Color(Color.WHITE, 1-timer/maxTime)
		timer-=delta
