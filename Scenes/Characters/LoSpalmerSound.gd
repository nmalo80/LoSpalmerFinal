extends Node

func _ready():
	pass

func play_effect(effect):
	$AudioStreamPlayer.stream = load(effect)	
	$AudioStreamPlayer.play()
	
func play_jump_effect():
	play_effect("res://Assets/Sound/Effects/jump.wav")

func play_dash_effect():
	play_effect("res://Assets/Sound/Effects/dash.wav")

func play_stomp_effect():
	play_effect("res://Assets/Sound/Effects/stomp.wav")
