extends Spell

@export var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	lifetime = 10
	set_meta("Element","Lightning")
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
	
func _on_area_2d_area_entered(area):
	if isEnemy(area) or isBoss(area):
		area.get_parent().takeDamage($HitBox)
		queue_free()
