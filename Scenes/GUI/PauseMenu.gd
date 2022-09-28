extends CanvasLayer


func _ready():
	get_tree().paused = true
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueButton.grab_focus()

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		unpause()
		get_tree().set_input_as_handled()
		
func unpause():
	queue_free()
	get_tree().paused = false
	
func _on_ContinueButton_pressed():
	unpause()

func _on_QuitButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/GUI/MainScreen.tscn")
	unpause()

func _on_LeaveLevelButton_pressed():
	GameManager.go_to_current_world_scene()
	unpause()
