extends Spell

@export var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	lifetime = 10
	set_meta("Element","Fire")
	super()

func _physics_process(delta):
	move_spell(delta)

func isEnemy(area)->bool:
	if area.is_inside_tree():
		if area.get_parent().get_meta("Type") == "Enemy":
			return area.get_meta("Type") !="Range"
	return false
	
func isBoss(area)->bool:
	if area.is_inside_tree():
		if area.get_parent().get_meta("Type") == "Boss":
			return area.get_meta("Type") !="Range"
	return false
	
func isInteractable(area)->bool:
	if area.is_inside_tree():
		return area.get_parent().get_meta("Type") == "Interactable"
	return false

func isPlayer(area):
	if area.is_inside_tree():
		if area.get_parent().get_meta("Type") == "Player":
			return true
	return false

func _on_hit_box_area_entered(area):
	if isEnemy(area) or isBoss(area) or isPlayer(area):
		area.get_parent().takeDamage($HitBox)
		queue_free()
	elif isInteractable(area):
		area.get_parent().interact($HitBox)
		queue_free()
	elif isSpell(area):
		queue_free()
		
func isSpell(area):
	if area.is_inside_tree():
		if area.get_parent().get_meta("Type") == "Spell":
			return true
	return false
