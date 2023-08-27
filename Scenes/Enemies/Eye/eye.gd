extends CharacterBody2D

var startPosition
var endPosition
var radius:float = 100

@export var speed = 40
@export var limit = 0.5
@export var still = false
@export var direction = "Right"

var facing = Vector2.ZERO

var timer = 0
var maxTime = 2
var player= null

var currSpell = preload("res://Viraj Stuff/ParticleEffects/BlueFireEffect.tscn")

@onready var ray = $Ray
@onready var animations = $AnimationPlayer

func _ready():
	startPosition = position
	endPosition = selectRandomCoordinate()
	set_meta("Type","Enemy")
	
func takeDamage(area):
	queue_free()

func selectRandomCoordinate() -> Vector2:
	var randomAngle: float = randf_range(0, 2 * PI)
	var randomDistance: float = randf_range(2*radius/3, radius)
	var xOffset: float = randomDistance * cos(randomAngle)
	var yOffset: float = randomDistance * sin(randomAngle)
	var randomCoord: Vector2 = startPosition + Vector2(xOffset, yOffset)
	return randomCoord
	
	
func updateVelocity():
	var moveDirection
	if still:
		moveDirection = Vector2.ZERO
	else:
		moveDirection = endPosition-position
		if moveDirection.length()<limit:
			changeDirection()
	velocity = moveDirection.normalized() * speed
	
func changeDirection():
	var temp = endPosition
	endPosition = startPosition
	startPosition = temp
	
func setRaycastDirection():
	if player != null:
		facing = player.global_transform.origin - global_transform.origin
		facing = facing.normalized()
		ray.rotation = facing.angle() if facing.angle()>=0 else facing.angle()+2*PI
		return
	match (direction):
		"Right":
			ray.rotation_degrees = 0
			facing = Vector2.RIGHT
		"Down":
			ray.rotation_degrees = 90
			facing = Vector2.DOWN
		"Left":
			ray.rotation_degrees = 180
			facing = Vector2.LEFT
		"Up":
			ray.rotation_degrees = 270
			facing = Vector2.UP

func updateAnimation():
	if velocity.length()==0:
		if player != null:
			if ray.rotation_degrees<45:
				direction = "Right"
			elif ray.rotation_degrees<45*3:
				direction = "Down"
			elif ray.rotation_degrees<45*5:
				direction = "Left"
			elif ray.rotation_degrees<45*7:
				direction = "Up"
			else: 
				direction = "Right"
	elif abs(velocity.y)> abs(velocity.x):
		direction = "Up"
		if velocity.y>0:
			direction = "Down"
	else:
		direction = "Right"
		if velocity.x<0:
			direction = "Left"
	animations.play("walk"+direction)
	setRaycastDirection()
	
func _physics_process(delta):
	if timer>0:
		timer-=delta
	handleRaycast()
	updateVelocity()
	move_and_slide()
	handleCollision()
	updateAnimation()
	
func handleRaycast():
	for area in ray.get_overlapping_areas():
		if isPlayer(area):
			if !player:
				player = area.get_parent()
			generateSpell()

func generateSpell():
	if timer>0:
		return
	var p = currSpell.instantiate()
	p.position = ray.global_position + facing*15
	p.velocity = facing*p.speed
	get_parent().add_child(p)
	timer = maxTime

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		endPosition = selectRandomCoordinate()

func isPlayer(area):
	if area.is_inside_tree():
		if area.get_parent().get_meta("Type") == "Player":
			return true
	return false
