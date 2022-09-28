extends Button

func _on_LeaveButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/GUI/MainScreen.tscn")
