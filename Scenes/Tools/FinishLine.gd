extends Area2D

var game_finished_scene = preload("res://Scenes/GUI/GameFinishedMenu.tscn")
var is_game_finished = false

func _ready():
	pass

func level_completed():
	get_tree().call_group("level", "stop_music")
	get_tree().call_group("player_state", "update_game_manager")
	$Sprite.visible = false
	$EffectTimer.start()	
	$LevelCompletedEffect.emitting = true
	$AudioStreamPlayer.play()
		
func _on_FinishLine_body_entered(body):
	if body.is_in_group("player"):
		level_completed()
		body.finish_level()
		is_game_finished = false
	elif body.is_in_group("GiantCrab"):
		$EnemyTimer.start()
		is_game_finished = true
		
func _on_EffectTimer_timeout():	
	get_tree().call_group("level", "update_game_manager_and_change_scene")
	
func _on_EnemyTimer_timeout():
	level_completed()
	get_tree().call_group("player", "finish_level", true)
	if is_game_finished:
		var game_finished_instance = game_finished_scene.instance()
		game_finished_instance.init(false)
		add_child(game_finished_instance)
