extends Node2D

var collected 

func _ready():
	$AnimationPlayer.current_animation = "default"
	collected = false
	get_tree().call_group("level", "increase_number_of_coins")
	
func _on_Area2D_body_entered(body):
	if collected:
		return 
		
	if body.is_in_group("player"):
		$AnimationPlayer.current_animation = "collected"
		collected = true	
		body.coin_collected()
		$CoinSound.play_sound_effect()
	
