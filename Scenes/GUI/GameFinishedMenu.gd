extends CanvasLayer

func init(is_100_percent):
	if is_100_percent:
		$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Label.text = \
			"You've collected\n  - All the coins\n  - All the Watermelons!\n\n\nYou Are a ZZZuper Player!!!\n\n"
	else:
		$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Label.text = \
			"Congratulations!\nYou beat the game!"

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
