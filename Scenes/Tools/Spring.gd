extends Node2D

export var jump_boost_multiplier = 1.5

func _ready():
	$AnimatedSprite.play("idle")

func _on_Spring_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("boost")
		body.boost_jump(jump_boost_multiplier)
		

