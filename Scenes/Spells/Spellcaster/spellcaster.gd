extends Node

@export var spells : Array[Node] = [null, null, null, null]
@export var can_cast := false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_spell(load("res://Scenes/Spell Managers/fireball_spell.tscn").instantiate(), 1)
	print(spells[1].name)
	cast_spell(1)
	can_cast = true
	cast_spell(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_spell(spell: Node, slot: int):
	print(spell.name)
	if slot >= 1 && slot <= 4:
		spells[slot] = spell
		spell.is_ready = true

# Casts the spell in the specified slot, if that spell is ready.
# Also starts the cooldown for that spell if it is successfully cast.
func cast_spell(slot: int):
	var spell = spells[slot]
	if can_cast && spell.is_ready:
		spell.cast()
		spell.is_ready = false
		print("Cooldown started")
		await get_tree().create_timer(spell.cooldown, false).timeout
		print("Cooldown ended")
		spell.is_ready = true
	else:
		print("casting of " + spell.name + " failed")
