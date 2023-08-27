extends CharacterBody2D

@export var speed: int=50
@onready var animations = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var weapon = $Wand

@onready var redTime = 0
@export var maxRedTime = 0.2
@onready var invincibleTime = 0
@export var addInvincibleTime = 0.25

@export var heartContainer: HBoxContainer

@export var maxHealth = 5
@onready var currHealth:int = maxHealth

@export var isAttacking:bool = false
@onready var direction = "Down"
var facing = Vector2.DOWN

@onready var knockbackArr = [300,300,500]
@onready var nextKnockback = null

@onready var hurtBox = $HurtBox

@onready var projectile = preload("res://Viraj Stuff/ParticleEffects/FireEffect.tscn")

func _ready():
	set_meta("Type","Player")

func handleInput():
	var moveDirection = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity=moveDirection*speed

func _input(event):
	if event.is_action_pressed("ui_select"):
		animations.play("attack"+direction)
		isAttacking = true
		generateSpell()

func generateSpell():
	var p = projectile.instantiate()
	p.position = weapon.global_position + facing*5
	if velocity!=Vector2.ZERO:
		p.velocity = velocity.normalized()*p.speed
	else:
		p.velocity = facing.normalized()*p.speed
	get_parent().add_child(p)

func updateAnimation(delta):
	if redTime>0:
		redTime-=1*delta
		if redTime<=0: sprite.set_modulate(Color(1.0, 1.0, 1.0))
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
	if invincibleTime>0:
		invincibleTime-=1*delta
	
	handleInput()
	updateAnimation(delta)
	handleKnockback()
	move_and_slide()
	handleCollision()

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

func _on_hurt_box_area_entered(area):
	if invincibleTime>0:
		return
	if isEnemy(area):
		takeDamage(area)
	elif isBoss(area):
		takeDamage(area, 2)

func takeDamage(area: Area2D,dmg = 1):
	invincibleTime = 0
	for i in range(dmg):
		currHealth-=1
		invincibleTime+=addInvincibleTime
		var heart = heartContainer.get_children()[currHealth]
		heart.get_children()[0].set_frame(4)
		
	if currHealth<=0:
		print_debug("Died")
		currHealth = maxHealth
		for heart in heartContainer.get_children():
			heart.get_children()[0].set_frame(0)
		return
		
	sprite.set_modulate(Color(1.0, 0.0, 0.0))
	redTime = maxRedTime
	#make sprite red when hurt
	
	knockback(area, dmg)

func knockback(area, dmg):
	var dir = -1*to_local(area.global_transform.origin)
	nextKnockback = dir.normalized()*knockbackArr[dmg]

func handleKnockback():
	#have to handle knockbacks in _physics_process
	if nextKnockback != null:
		velocity+= nextKnockback
		nextKnockback = null
