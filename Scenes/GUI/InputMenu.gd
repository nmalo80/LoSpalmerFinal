extends Control

func _ready():
	GameManager.load_input_values()
	set_focus()

func set_focus():
	$CenterContainer/VBoxContainer/Left/RemapLeft.grab_focus()
	
