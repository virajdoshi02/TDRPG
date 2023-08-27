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

func _on_hit_box_area_entered(area):
	if isEnemy(area):
		area.get_parent().takeDamage()
	elif isBoss(area):
		player.knockback(area,0)
	elif isPlant(area):#don't have yet
		area.get_parent().queue_free()

func isPlant(area)->bool:
	if area.is_inside_tree():
		if area.get_parent().get_meta("Type") == "Plant":
			return true
	return false

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
