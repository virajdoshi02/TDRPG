extends CharacterBody2D

var startPosition
var endPosition
var radius:float = 100

@export var speed = 50
@export var limit = 5

@onready var animations = $AnimationPlayer

@onready var isAggro = false

var player

@onready var reversing = false

func _ready():
	startPosition = position
	endPosition = selectRandomCoordinate()
	set_meta("Type","Enemy")
	
func selectRandomCoordinate() -> Vector2:
	var randomAngle: float = randf_range(0, 2 * PI)
	var randomDistance: float = randf_range(2*radius/3, radius)
	var xOffset: float = randomDistance * cos(randomAngle)
	var yOffset: float = randomDistance * sin(randomAngle)
	var randomCoord: Vector2 = startPosition + Vector2(xOffset, yOffset)
	return randomCoord
	
func updateVelocity():
	var moveDirection
	if !isAggro:
		moveDirection = endPosition-position
		if moveDirection.length()<limit:
			changeDirection()
			#to prevent jitter
	else:
		moveDirection = to_local(endPosition.global_transform.origin)
	velocity = moveDirection.normalized() * speed
	
func changeDirection():
	var temp = endPosition
	endPosition = startPosition
	startPosition = temp
	
func updateAnimation():
	if velocity.length()==0:
		if animations.is_playing(): animations.stop()
		return
	var animationString = ""
	if abs(velocity.y)> abs(velocity.x):
		animationString = "walkUp"
		if velocity.y>0:
			animationString = "walkDown"
	else:
		animationString = "walkRight"
		if velocity.x<0:
			animationString = "walkLeft"
	animations.play(animationString)
	
func _physics_process(delta):
	updateVelocity()
	move_and_slide()
	handleCollision()
	updateAnimation()
	
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if !isAggro:
			if collider.name == "TileMap":
				endPosition = selectRandomCoordinate()
				#creates new target every time it collides

func _on_aggro_range_area_entered(area):
	if isPlayer(area):
		isAggro = true
		player = area.get_parent()
		endPosition = player

func isPlayer(area):
	if area.is_inside_tree():
		if area.get_parent().get_meta("Type") == "Player":
			return true
	return false

func takeDamage(area):
	queue_free()

func _on_hit_box_area_entered(area):
	if isPlayer(area):
		if !reversing:
			reverseDirection(area)

func reverseDirection(area):
	print_debug("Reverse")
	reversing = true
	var dir = -1*to_local(area.global_transform.origin)
	var x = Node2D.new()
	x.position = position + 10*dir
	endPosition = x


func _on_hit_box_area_exited(area):
	if isPlayer(area):
		if reversing:
			endPosition = player
			reversing = false
