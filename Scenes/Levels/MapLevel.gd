extends Sprite

export var allow_direction_left = false
export var allow_direction_right = false
export var allow_direction_up = false
export var allow_direction_down = false
export var level_scene = ""
export var level_number = 0

func _on_Area2D_body_entered(body):
	if body.is_in_group("map_character"):
		body.stop(level_number)
		body.allow_direction_left = allow_direction_left
		body.allow_direction_right = allow_direction_right
		body.allow_direction_up = allow_direction_up
		body.allow_direction_down = allow_direction_down
		
		get_tree().call_group("base_map", "update_ui", level_number)
