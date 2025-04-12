extends Area2D


# Called when the node enters the scene tree for the first time.
@onready var game_manager: Node = %"Game Manager"



func _on_body_entered(body: Node2D) -> void:
	game_manager.add_point()
	queue_free() # Replace with function body.
