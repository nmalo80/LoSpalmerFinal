extends Button

func _on_InputDoneButton_pressed():
	GameManager.save_input_values()
	GameManager.load_input_values()
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/GUI/MainScreen.tscn")

