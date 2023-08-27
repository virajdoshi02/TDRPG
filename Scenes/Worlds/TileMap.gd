extends TileMap

signal game_finished

func removeWall(p:Vector2, gameFinished = false): 
	var pos = local_to_map(p)
	for i in range(-5,5):
		for j in range(-5,5):
			erase_cell(2,pos+Vector2i(i,j))
			
	if gameFinished:
		emit_signal("game_finished")
