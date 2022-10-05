extends Button

# Use InputEventKey for keyboard input
# Use InputEventJoypadButton for controller input
export(String) var input_event_type = ""

export(String) var game_action = "up"
export(String) var ui_action = "ui_up"


var temp_text = ""
var enter_key_text = "... Key"
var has_prev_button_been_released = true

func _ready():
	assert(InputMap.has_action(game_action))
	set_process_unhandled_input(false)
	display_current_key()

# this will be removed when I save the input config
func display_current_key():
	if input_event_type == 'InputEventKey': 
		var current_key = InputMap.get_action_list(game_action)[0].as_text()
		text = "  %s Key  " % current_key
	elif input_event_type == 'InputEventJoypadButton':
		var current_key = InputMap.get_action_list(game_action)[1].button_index
		text = "Button %s" % current_key		

func _toggled(button_pressed):
	if not has_prev_button_been_released:
		#toggle_mode = false
		button_pressed = false
		return		
	
	# avoids the key pressed to propagate
	get_tree().set_input_as_handled()
	
	set_process_unhandled_input(button_pressed)
	
	#if the button loses the focus before a selection has been made, restore original value
	if text == enter_key_text:
		text = temp_text
		
	if button_pressed:
		temp_text = text
		text = enter_key_text
		
func _unhandled_input(event):		
	# If I'm waiting for a keyboard input, and I get a joypad input => pass
	if event.get_class() == input_event_type:		
		# remap_action_to returns false if the action is a duplicate
		if(remap_action_to(event, game_action, ui_action)):
			assign_text_to_button(event)			
			
			#tells the input system to stop listening for events 
			set_process_unhandled_input(false)	
						
		pressed = false
		get_node(focus_neighbour_bottom).grab_focus()
		
func assign_text_to_button(event):
	if input_event_type == "InputEventJoypadButton":
		text = "Button %s" % event.button_index	
	elif input_event_type == "InputEventKey":
		text = "%s Key" % event.as_text()
	
	var current_event = event.as_text() 
	
	#this prevents the problems that I have when I remap to the button that corresponds to ui_accept
	for e in InputMap.get_action_list("ui_accept"):
		if current_event == e.as_text():
			has_prev_button_been_released = true		
			return false
		
	# avoids the key pressed to propagate
	get_tree().set_input_as_handled()
	
	return true
	
func remap_action_to(event, action, my_ui_action):
	var return_value = false	
	
	if input_event_type == 'InputEventKey': 
		return_value = GameManager.edit_keyboard_input_value(action, my_ui_action, event)
	elif input_event_type == 'InputEventJoypadButton':
		return_value = GameManager.edit_joypad_input_value(action, my_ui_action, event)
	
	return return_value
	
func _on_RemapButton_button_up():
	has_prev_button_been_released = true
	

# Note, this is how a joypad event is saved (as_text):
# "run":"InputEventJoypadButton : button_index=2, pressed=true, pressure=0"
# I'm saving just the button_index, everything else is constant
