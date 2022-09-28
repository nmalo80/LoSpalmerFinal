extends Node2D

export var new_speed = 100.0

export var destroy = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("GiantCrab"):
		body.speed = new_speed
		
		if destroy:
			body.destroy()
