extends Node2D

export var enabled = true
export var check_point_number = 0

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if enabled and body.is_in_group("player"):
		$Sprite.modulate = Color(.6,.6,.6,.25)
		enabled = false
		get_tree().call_group("level", "assign_check_point", check_point_number)
