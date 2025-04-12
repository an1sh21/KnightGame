extends Node

@onready var label_6: Label = $Label6

# Called when the node enters the scene tree for the first time.
var score = 0

func add_point():
	score += 1
	label_6.text = "You collected" + str(score) + "coins "
