extends Button

func _on_RestoreDefaultsButton_pressed():
	GameManager.restore_default_input()
	GameManager.load_input_values()
	GameManager.save_input_values()
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/GUI/InputMenu.tscn")
