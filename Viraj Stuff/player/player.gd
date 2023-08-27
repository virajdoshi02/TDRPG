extends CharacterBody2D

class_name Player

signal death

@export var speed: int=60
@onready var animations = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var weapon = $Wand

@onready var invincibleTime = 0
@export var addInvincibleTime = 0.4

@export var heartContainer: HBoxContainer
@export var inventory: Control

@export var maxHealth = 3
@onready var currHealth:int = maxHealth

@export var isAttacking:bool = false
@onready var direction = "Down"
var facing = Vector2.DOWN

@onready var knockbackArr = [500,500,700]
@onready var nextKnockback = null

@onready var hurtBox = $HurtBox

@onready var spells = [null,null,null,null,null]
@onready var numSpells = 0
@export var spellSlots:Control
var currSpell = null
var spellTime = 1

func _ready():
	set_meta("Type","Player")

func give(item:InventoryItem):
	return inventory.add(item)
	
func take(item:InventoryItem):
	return inventory.remove(item)

func has (item:InventoryItem):
	return inventory.contains(item)

func handleInput():
	var moveDirection = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity=moveDirection*speed

func _input(event):
	if event.is_action_pressed("ui_select"):
		animations.play("attack"+direction)
		isAttacking = true
		generateSpell()
	if event.is_action_pressed("spell_slot_1"):
		currSpell = spells[0]
		spellSlots.changeOpenSlot(0)
	if event.is_action_pressed("spell_slot_2"):
		currSpell = spells[1]
		spellSlots.changeOpenSlot(1)

func generateSpell():
	if currSpell == null:
		return
	if not spellSlots.getTimerFinished():
		return
	var p = currSpell.instantiate()
	p.position = weapon.global_position + facing*5
	if velocity!=Vector2.ZERO:
		p.velocity = velocity.normalized()*p.speed
	else:
		p.velocity = facing*p.speed
	get_parent().add_child(p)
	spellSlots.setTimer(spellTime)
	
func updateAnimation(delta):
	if invincibleTime>0:
		invincibleTime-=1*delta
		if invincibleTime<=0: sprite.set_modulate(Color(1.0, 1.0, 1.0))
	#make sprite normal again
	
	if isAttacking:
		velocity = Vector2.ZERO
		if !animations.is_playing():
			isAttacking = false
		return
	if velocity.length()==0:
		if animations.is_playing(): animations.stop()
		return
	var direction = "Down"
	if velocity.x<0: 
		direction = "Left"
		facing = Vector2.LEFT
	elif velocity.x>0: 
		direction = "Right"
		facing = Vector2.RIGHT
	elif velocity.y<0: 
		direction = "Up"
		facing = Vector2.UP
	else:
		facing = Vector2.DOWN
	self.direction = direction
	animations.play("walk"+direction)

func _physics_process(delta):
	handleInput()
	updateAnimation(delta)
	handleKnockback()
	move_and_slide()
	handleCollision()
	
	for area in hurtBox.get_overlapping_areas():
		if invincibleTime>0:
			return
		if isEnemy(area):
			takeDamage(area)
		elif isBoss(area):
			takeDamage(area, 2)

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		#print_debug(collider.name)

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

func isCollectible(area)->bool:
	return area.get_meta("Type")=="Collectible"

func _on_hurt_box_area_entered(area):
	if isCollectible(area):
		area.collect(get_parent().get_child(0))

func healDamage(dmg = 1):
	for i in range(dmg):
		currHealth+=1
		if currHealth>maxHealth:
			currHealth = maxHealth
			return
		var heart = heartContainer.get_children()[currHealth-1]
		heart.get_children()[0].set_frame(0)

func addSpell(spell):
	spells[numSpells] = spell
	numSpells+=1

func addToSpellSlots(sprite):
	spellSlots.addSpell(sprite)

func takeDamage(area: Area2D,dmg = 1):
	invincibleTime = 0
	for i in range(dmg):
		currHealth-=1
		invincibleTime+=addInvincibleTime
		var heart = heartContainer.get_children()[currHealth]
		heart.get_children()[0].set_frame(4)
		
	if currHealth<=0:
		die()
		
	sprite.set_modulate(Color(1.0, 0.0, 0.0))
	#make sprite red when hurt
	
	knockback(area, dmg)

func die():
	emit_signal("death")

func knockback(area, dmg):
	var dir = -1*to_local(area.global_transform.origin)
	nextKnockback = dir.normalized()*knockbackArr[dmg]

func handleKnockback():
	#have to handle knockbacks in _physics_process
	if nextKnockback != null:
		velocity+= nextKnockback
		nextKnockback = null
