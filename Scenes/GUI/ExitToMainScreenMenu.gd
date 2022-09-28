extends CanvasLayer

func _ready():
	get_tree().paused = true
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/NoButton.grab_focus()

func _on_YesButton_pressed():
	get_tree().paused = false
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/GUI/MainScreen.tscn")

func _on_NoButton_pressed():
	get_tree().paused = false
	queue_free()
