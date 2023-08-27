extends CharacterBody2D

var startPosition
var endPosition
var radius:float = 100

@export var speed = 50
@export var limit = 0.5
@export var still = false

@export var isAggro = false
var player

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
	if !isAggro:
		if still:
			moveDirection = Vector2.ZERO
		else:
			moveDirection = endPosition-position
			if moveDirection.length()<limit:
				changeDirection()
	else:
		moveDirection = to_local(player.global_transform.origin)
	velocity = moveDirection.normalized() * speed
	
func changeDirection():
	var temp = endPosition
	endPosition = startPosition
	startPosition = temp
	
func updateAnimation():
	if velocity.length()==0:
		animations.play("walkDown")
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
		endPosition = selectRandomCoordinate()

func isPlayer(area):
	if area.is_inside_tree():
		if area.get_parent().get_meta("Type") == "Player":
			return true
	return false

func _on_aggro_range_area_entered(area):
	if isPlayer(area):
		isAggro = true
		player = area.get_parent()
