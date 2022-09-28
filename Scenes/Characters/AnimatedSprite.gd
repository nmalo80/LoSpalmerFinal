extends AnimatedSprite

var STATES

func _ready():
	STATES = get_node("..").get("STATES")
	
func manage_flip_status(motion):
	if motion.x > 0:
		flip_h = false
	elif motion.x < 0:
		flip_h = true

func _on_LoSpalmer_animate(_velocity, _current_state):
	pass # Replace with function body.
