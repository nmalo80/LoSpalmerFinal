extends Node2D

export var world_number: int
export var level_number: int

var pause_scene = preload("res://Scenes/GUI/PauseMenu.tscn")

var total_number_of_coins = 0

func _ready():
	randomize()
	$LevelSoundEffects/MainTune.playing = true
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_scene_instance = pause_scene.instance()
		add_child(pause_scene_instance)

func stop_music():
	$LevelSoundEffects/MainTune.playing = false

func increase_number_of_coins():
	total_number_of_coins += 1
	
func update_game_manager_and_change_scene():	
	GameManager.update_level_details(world_number, level_number, true, total_number_of_coins)
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Levels/MapWorld_%s.tscn" % str(world_number))

func change_scene_after_dying():
	$DeathTimer.start()

func _on_DeathTimer_timeout():
	# warning-ignore:return_value_discarded
	#get_tree().change_scene("res://Scenes/Levels/MapWorld_%s.tscn" % str(world_number))
	GameManager.go_to_level_scene(level_number)

