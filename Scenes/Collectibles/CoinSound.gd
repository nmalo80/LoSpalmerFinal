extends Node

func _ready():
	pass

func play_effect(effect):
	$AudioStreamPlayer.stream = load(effect)
	$AudioStreamPlayer.volume_db = -12
	$AudioStreamPlayer.play()
	
func play_sound_effect():
	play_effect("res://Assets/Sound/Effects/coin.wav")
