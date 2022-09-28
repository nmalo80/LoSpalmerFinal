extends Node

func _ready():
	pass

func play_effect(effect, volume):
	$SoundEffects.stream = load(effect)
	$SoundEffects.volume_db = volume
	$SoundEffects.play()
	
func play_player_die_effect():
	play_effect("res://Assets/Sound/Effects/splat_die.ogg", 0)

func play_enemy_die_effect():
	play_effect("res://Assets/Sound/Effects/splat.ogg", -20)


