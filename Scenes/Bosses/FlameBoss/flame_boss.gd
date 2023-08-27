extends CharacterBody2D

@export var speed: int=50
@export var angrySpeed: int=100
@onready var animations = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var limit = 1
@onready var heartContainer = $HeartContainer

@export var maxHealth = 5
@onready var currHealth:int = maxHealth
@onready var invincibleTime = 0
@export var maxInvincibleTime = 1

@export var marker_paths: Array[NodePath]
@onready var markers = marker_paths.map(get_node) 

@export var arena: Area2D
@onready var target = 0
var xDim
var yDim

@export var player: CharacterBody2D
@onready var isPlaying = false

func _physics_process(delta):
	if !isPlaying:
		if arena.hasEntered:
			isPlaying = true
			player = arena.player
		return
	if invincibleTime>0:
		invincibleTime-=delta
	updateVelocity()
	updateAnimation()
	move_and_slide()

func updateVelocity():
	var moveDirection = arena.to_local(markers[target].global_transform.origin)-position
	if moveDirection.length()<limit:
		target=(target+1) % markers.size()
	velocity = moveDirection.normalized() * speed

func updateAnimation():
	if !animations.is_playing():
		animations.play("idle")

func _ready():
	set_meta("Type","Boss")
	var rect = arena.get_child(0).shape
	xDim = rect.extents.x
	yDim = rect.extents.y
	heartContainer.setMaxHearts(maxHealth)

func _on_hit_box_area_entered(area):
	if invincibleTime>0:
		return

func takeDamage(area):
	currHealth-=1
	var heart = heartContainer.get_children()[currHealth]
	heart.get_children()[0].set_frame(4)	
	if currHealth<=0:
		queue_free()
		arena.removeWall()
	
	invincibleTime = maxInvincibleTime
	var dir = area.position-position
	animations.play("hit")
	changePhase()

func changePhase():
	target = -1
	match (currHealth):
		1:
			print_debug("Final Phase")
			animations.queue("angry")
			markers.shuffle()
			markers.append(player.duplicate())
			speed = angrySpeed
		_:
			markers.shuffle()

func getRandomPoint():
	return Vector2(randf_range(-xDim/2,xDim/2),randf_range(-yDim/2,yDim/2))
