extends CanvasLayer

func _ready():
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/NoButton.grab_focus()

func _on_YesButton_pressed():
	GameManager.init_and_start_new_game()

func _on_NoButton_pressed():
	get_tree().call_group("gui_main_screen", "set_focus")
	queue_free()
