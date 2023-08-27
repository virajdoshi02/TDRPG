extends CollectibleSpell

var spell = preload("res://Viraj Stuff/ParticleEffects/FireEffect.tscn")
@onready var sprite = $Sprite2D.texture

func collect(player:Player):
	player.addSpell(spell)
	player.addToSpellSlots(sprite)
	super(player)

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug(sprite)
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
