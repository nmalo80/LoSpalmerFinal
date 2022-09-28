extends Camera2D

# this is an alternative to placing the camera in the player scene

var target_position = Vector2.ZERO

export(Color, RGB) var background_color

func _ready():
	pass
	
func _process(delta):
	acquire_target_position()	
	global_position = lerp(target_position, global_position, pow(2, -15 * delta))
	
func acquire_target_position():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		target_position = player.global_position
