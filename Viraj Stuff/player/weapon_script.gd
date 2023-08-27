extends Sprite2D

var player
var hitBox
# Called when the node enters the scene tree for the first time.
func _ready():
	player= get_parent()
	hitBox = get_node("HitBox")
	set_meta("Type","Weapon")

func _physics_process(delta):
	if player.get("isAttacking"):
		if !hitBox.get("monitoring"):
			hitBox.set("monitoring",true)
			hitBox.set("monitorable",true)
	else:
		if hitBox.get("monitoring"):
			hitBox.set("monitoring",false)
			hitBox.set("monitorable",false)

func isInteractable(area)->bool:
	if area.is_inside_tree():
		return area.get_parent().get_meta("Type") == "Interactable"
	return false

func _on_hit_box_area_entered(area):
	if isInteractable(area):
		area.get_parent().interact($HitBox)
