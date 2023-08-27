extends Button

@onready var arrow = $Arrow

func setText(t):
	text = t
	

func switchArrow():
	arrow.visible = !arrow.visible

func arrowOff():
	arrow.visible = false
	
func arrowOn():
	arrow.visible = true
