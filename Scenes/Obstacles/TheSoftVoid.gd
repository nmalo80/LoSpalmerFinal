extends Area2D

func _on_TheVoid_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_group("level", "reset_position")
	else:
		body.queue_free()
