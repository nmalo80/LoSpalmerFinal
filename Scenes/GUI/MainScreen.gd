extends Control

var confirmation_scene = preload("res://Scenes/GUI/ConfirmationMenu.tscn")

func _ready():
	set_focus()

func set_focus():
	$CenterContainer/VBoxContainer/LoadGameButton.grab_focus()
	
func _on_QuitButton_pressed():
	get_tree().quit()

func _on_NewGameButton_pressed():
	var confirmation_scene_instance = confirmation_scene.instance()
	add_child(confirmation_scene_instance)
	
func _on_LoadGameButton_pressed():
	GameManager.init_game_manager(false)

func _on_InputButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/GUI/InputMenu.tscn")
