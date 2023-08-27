extends Control

var numSpells = 0
@onready var grid = $NinePatchRect/GridContainer
var currOpenSlot = -1

func addSpell(sprite):
	grid.get_child(numSpells).get_child(1).texture = sprite
	numSpells+=1

func openSlot(i):
	grid.get_child(i).get_child(0).frame = 1
	currOpenSlot = i

func closeSlot(i):
	grid.get_child(i).get_child(0).frame = 0
	
func setTimer(time, slot = currOpenSlot):
	grid.get_child(slot).activateTimer(time)

func getTimerFinished(slot = currOpenSlot):
	return grid.get_child(slot).getTimerFinished()

func getOpenSlot():
	return currOpenSlot

func changeOpenSlot(i):
	if grid.get_child(i).get_child(1).texture == null:
		return
	if currOpenSlot == -1:
		openSlot(i)
	else:
		closeSlot(currOpenSlot)
		openSlot(i)
	
