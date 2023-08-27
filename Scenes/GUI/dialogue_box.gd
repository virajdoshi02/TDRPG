extends Control

var output = [] 
@onready var textBox = $DialogueText
var textSpeed = 30 # num characters per second
@onready var choices = $ChoiceList
@onready var Name = $NameText
var dialogueChoice = preload("res://Scenes/GUI/dialogue_choice.tscn")
var choosing:bool = false
var choiceCursor = -1
var arrowTimer = 0
var maxArrowTime = 0.8

signal dialogue_ended

func addChoice(text:String, function:Callable):
	var c = dialogueChoice.instantiate()
	c.setText(text)
	c.pressed.connect(function)
	output.push_back(c)

func removeAllChoices():
	for e in choices.get_children():
		e.queue_free()
	choosing = false
	choiceCursor = -1
	advanceText()

func addOutput(o:String):
	var arr = o.split("\\")
	for e in arr:
		output.push_back(e.strip_escapes().strip_edges())
	if textBox.text == "":
		advanceText()

func animateText(t:String):
	if t.contains(":"):
		var a = t.split(":")
		Name.text = "[center]"+a[0]
		t = a[1]
	textBox.text = t
	textBox.visible_ratio = 0

func _process(delta):
	if textBox.visible_ratio<1:
		textBox.visible_ratio+=delta*textSpeed/textBox.get_total_character_count()
	else:
		if !output.is_empty() and typeof(output[0]) != TYPE_STRING:
			advanceText()
	if arrowTimer<maxArrowTime:
		arrowTimer+=delta
	else:
		arrowTimer = 0
		if choosing:
			choices.get_child(choiceCursor).switchArrow()
		if "\t >" in textBox.text:
			textBox.text = textBox.text.left(textBox.text.length()-"\t >".length())
		else:
			textBox.text += "\t >"

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select") or event.is_action_pressed("ui_right"):
		if textBox.visible_ratio<1:
			textBox.visible_ratio=1
		else:
			if !choosing:
				advanceText()
			else:
				choices.get_child(choiceCursor).emit_signal("pressed")
		
	elif event.is_action_pressed("ui_down") and choosing:
		choices.get_child(choiceCursor).arrowOff()
		choiceCursor = (choiceCursor-1) % choices.get_child_count()
		choices.get_child(choiceCursor).arrowOn()
		
	elif event.is_action_pressed("ui_up") and choosing:
		choices.get_child(choiceCursor).arrowOff()
		choiceCursor = (choiceCursor+1) % choices.get_child_count()
		choices.get_child(choiceCursor).arrowOn()

func advanceText():
	if output.is_empty():
		if choosing:
			choiceCursor = 0
			choices.get_child(choiceCursor).switchArrow()
			return
		emit_signal("dialogue_ended")
		queue_free()
	else:
		if !choosing and typeof(output[0]) == TYPE_STRING:
			animateText(output[0])
			output.pop_front()
		elif choosing and typeof(output[0]) == TYPE_STRING:
			return
		else:
			choices.add_child(output[0])
			if !choosing:
				choosing = true
			output.pop_front()
			advanceText()
			return
	
func _enter_tree():
	get_tree().paused = true

func _exit_tree():
	get_tree().paused = false
