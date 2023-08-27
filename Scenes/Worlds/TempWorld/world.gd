extends Node2D

#like game manager
var dialogueBox = preload("res://Scenes/GUI/dialogue_box.tscn")
@export var key:InventoryItem

@onready var canvas = $GUICanvas
@onready var heartContainer = $GUICanvas/HeartContainer
@onready var player = $TileMap/Player
@onready var gameOverScreen = $GUICanvas/GameOverScreen

@export var firstEncounterAggressiveSlime1: CharacterBody2D
@export var firstEncounterAggressiveSlime2: CharacterBody2D
var firstEncounterDone = false
var firstSpellDone = false
var hadKey = false

func _ready():
	heartContainer.setMaxHearts(player.maxHealth)
	canvas.createDialogueBox(startingDialogue)

func _on_player_death():
	gameOverScreen.visible = true
	get_tree().paused = true

func _process(delta):
	if !firstEncounterDone and (firstEncounterAggressiveSlime1.isAggro or firstEncounterAggressiveSlime2.isAggro):
		firstEncounterDone = true
		canvas.createDialogueBox(firstEncounterDialogue)
	if !firstSpellDone and player.numSpells==1:
		firstSpellDone = true
		canvas.createDialogueBox(firstSpellDialogue)
	if !hadKey and player.has(key):
		hadKey = true
		canvas.createDialogueBox(getKeyDialogue)
	
func getKeyDialogue():
	if not canvas.has_node("DialogueBox"):
		var box = dialogueBox.instantiate()
		canvas.add_child(box)
		box.addOutput("???:A Silver Key?
		\\That looks important, but I can't remember where I saw the keyhole...
		\\Anyways, press I to open your inventory and look at the key!
		\\Not that looking at the key will get us out of here anyways...")

func firstSpellDialogue():
	if not canvas.has_node("DialogueBox"):
		var box = dialogueBox.instantiate()
		canvas.add_child(box)
		box.addOutput("???:Ah! There's finally a spell!
		\\This is the Fireball spell!
		\\Fire it at that slime to kill it!
		\\Press 1 to activate it, then press the Spacebar to fire!
		\\Be careful though... it takes some time to recharge!")
	
func firstEncounterDialogue():
	if not canvas.has_node("DialogueBox"):
		var box = dialogueBox.instantiate()
		canvas.add_child(box)
		box.addOutput("???:Crap! That's not good!
		\\You've been noticed by a dangerous one! It'll chase you till the ends of the earth!
		\\You don't have any spells right now... just run until you find one!")

func isPlayer(area):
	if area.is_inside_tree():
		if area.get_parent().get_meta("Type") == "Player":
			return true
	return false

func _on_keyhole_area_area_entered(area):
	if !isPlayer(area):
		return
	if !player.has(key):
		return
	if not canvas.has_node("DialogueBox"):
		var box = dialogueBox.instantiate()
		canvas.add_child(box)
		box.addOutput("???:It looks like that key you found goes into this hole...
		\\Walk up to the hole and press the Spacebar to use the key!")

func startingDialogue():
	if not has_node("DialogueBox"):
		var box = dialogueBox.instantiate()
		canvas.add_child(box)
		box.addOutput("???:...
		\\...........
		\\Oh! You're finally awake!
		\\Thank god! Do you know how sad I'd have been if you died?
		\\The others are all dead! I've been all alone with these disgusting things for a long time now...
		\\Please help me leave!
		\\You'll help..... right?")
		var lambda = func(function:Callable):
			box.addChoice("Sure!", 
			func(): 
				box.addOutput("Thank god! Let's go then!")
				box.removeAllChoices()
				box.addOutput("Huh? You can't see me?
				\\Well... I'm always with you! Don't fret the details!
				\\Let's go now!"))
			box.addChoice("Nah.", 
			func(): 
				box.addOutput("Come on! Please?")
				function.call(function)
				box.removeAllChoices()
				)
		lambda.call(lambda)

func _on_tile_map_game_finished():
	if not canvas.has_node("DialogueBox"):
		var box = dialogueBox.instantiate()
		canvas.add_child(box)
		box.addOutput("???:We're out! Finally!
		\\Thank you so much for freeing me!
		\\Huh? Who am I?
		\\Don't fret the details! I'm just the guy that helped you out!
		\\Let's go now!")
		await box.dialogue_ended
		get_tree().change_scene_to_file("res://Scenes/Worlds/end_scene.tscn")
