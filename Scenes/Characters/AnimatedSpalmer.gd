extends "res://Scenes/Characters/AnimatedSprite.gd"

func _ready():
	pass
		
func _on_LoSpalmer_animate(velocity, current_state):
	#var current_status = (get_node("..").get("current_state"))
	manage_flip_status(velocity)
	
	match current_state: 
		STATES.DASH: play("dash")
		STATES.CROUCH: play("crouch")
		STATES.WALK: play("walk")
		STATES.RUN: play("run")
		STATES.JUMP_HANGING: play("hang")
		STATES.JUMP: play("jump")
		_: play("idle")
