extends Node2D

var collected

func _ready():
	collected = false

func _on_Area2D_body_entered(body):
	if collected:
		return 
		
	if body.is_in_group("player"):
		$AnimationPlayer.current_animation = "collected"
		collected = true	
		body.zuparicu_collected()		
		$WatermelonSound.play_sound_effect()
