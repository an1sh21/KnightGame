extends Area2D


# Called when the node enters the scene tree for the first time.



func _on_body_entered(body: Node2D) -> void:
	print("+! coin")
	queue_free() # Replace with function body.
