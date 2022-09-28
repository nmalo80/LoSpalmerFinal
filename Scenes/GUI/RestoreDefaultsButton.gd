extends Button

func _on_RestoreDefaultsButton_pressed():
	GameManager.load_input_values(true)
	GameManager.save_input_values()
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/GUI/InputMenu.tscn")
