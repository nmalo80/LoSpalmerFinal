extends Node

# "user://" on Linux is stored in:
# /home/fed/.var/app/org.godotengine.Godot/data/godot/app_userdata/LoSpalmerIteration4
# or
# /home/fed/.local/share/godot/app_userdata/LoSpalmerIteration4/
var save_file_path = "user://savegame.save"
var save_input_config_path = "user://input_config.save"
var save_input_config_path_defaults = "user://input_config_defaults.save"

#------------------ World Map Class ----------------- #
class WorldMap:
	var completed
	var numbers_of_levels
	var levels = []	

	func _init(_completed = false, _levels = []):
		completed = _completed
		levels = _levels
		numbers_of_levels = levels.size()
	
	func add_level(level):
		levels.append(level)
		numbers_of_levels = levels.size()
	
	func get_save_data():
		var save_dict = {
				"completed" : completed,
				"numbers_of_levels" : numbers_of_levels
			}
		
		for i in range(len(levels)):
			save_dict["level_" + str(i)] = levels[i].get_save_data()
		
		return save_dict
#------------------ World Map Class ----------------- #

#------------------ Level Class ----------------- #		
class Level:
	var completed: bool
	var total_number_of_coins: int
	var number_of_collected_coins: int
	var water_melon_collected: bool
			
	func _init(_completed = false, _total_number_of_coins = 0, \
			   _number_of_collected_coins = 0, _water_melon_collected = false):
		completed = _completed
		total_number_of_coins = _total_number_of_coins
		number_of_collected_coins = _number_of_collected_coins
		water_melon_collected = _water_melon_collected
	
	func get_save_data():
		var save_dict = {
			"completed" : completed,
			"total_number_of_coins" : total_number_of_coins,
			"number_of_collected_coins" : number_of_collected_coins,
			"water_melon_collected" : water_melon_collected
		}
		return save_dict
#------------------ Level Class ----------------- #		
	
var world_maps = []
var current_world = 0
var current_level = 0
var current_character_position_in_map = Vector2.ZERO

var input_keyboard_game_actions_dict = {
	"up":null, 
	"crouch": null, 
	"left":null, 
	"right":null, 
	"jump":null, 
	"run":null, 
	"dash":null, 
	"pause":null
	}
	
var input_keyboard_ui_actions_dict = {
	"ui_up":null, "ui_down":null, "ui_left":null,"ui_right":null,"ui_accept":null,"ui_cancel":null
}

var input_joypad_game_actions_dict = {
	"up":null, 
	"crouch": null, 
	"left":null, 
	"right":null, 
	"jump":null, 
	"run":null, 
	"dash":null, 
	"pause":null
	}

var input_joypad_ui_actions_dict = {
	"ui_up":null, "ui_down":null, "ui_left":null,"ui_right":null,"ui_accept":null,"ui_cancel":null
}

func _init():
	load_input_values()
	
func init_game_manager(new_game):
	if new_game:
		init_new_game()
	else:
		read_saved_data()
		
func init_new_game():
	var world_0 = WorldMap.new()
	for _i in range(8):
		world_0.add_level(Level.new())
	world_maps = []
	world_maps.append(world_0)

func init_and_start_new_game():
	init_new_game()
	go_to_current_world_scene()

func go_to_current_world_scene():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Levels/MapWorld_%d.tscn" % current_world)
	
func go_to_world_scene(index):
	current_world = index
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Levels/MapWorld_%d.tscn" % index)

func go_to_level_scene(index)	:
	current_level = index
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Levels/Level_%d_%d.tscn" % [current_world, index])

func set_level_collected_coins(value):
	if world_maps != null and world_maps.size() > 0:
		if value > world_maps[current_world].levels[current_level].number_of_collected_coins:
			world_maps[current_world].levels[current_level].number_of_collected_coins = value
	
func set_level_watermelon(value):
	if world_maps != null and world_maps.size() > 0:
		if not world_maps[current_world].levels[current_level].water_melon_collected:
			world_maps[current_world].levels[current_level].water_melon_collected = value

func read_saved_data():
	var save_game_file = File.new()
	
	if not save_game_file.file_exists(save_file_path):
		#if the save file doesn't exist, just return. The user will need to start a new game
		return
	
	# We need to revert the game state so we're not cloning objects during loading. 
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for game_manager in save_nodes:
		game_manager.clean_data()
				
	save_game_file.open(save_file_path, File.READ)
	
	while save_game_file.get_position() < save_game_file.get_len():
		# Get the saved dictionary from the next line in the save file
		var world_map_json = parse_json(save_game_file.get_line())
		var world_map = WorldMap.new()
		
		#note: manage this 0 with a for loop if I want to add worlds
		world_map.completed = world_map_json["world_maps_0"]["completed"] 
		world_map.numbers_of_levels = world_map_json["world_maps_0"]["numbers_of_levels"]
		
		for i in range(world_map.numbers_of_levels):
			var level_json = world_map_json["world_maps_0"]["level_%d" % i]
			var completed = level_json["completed"]
			var number_of_collected_coins = level_json["number_of_collected_coins"]
			var total_number_of_coins = level_json["total_number_of_coins"]
			var water_melon_collected = level_json["water_melon_collected"]
			
			var level = Level.new(completed, total_number_of_coins, \
						number_of_collected_coins, water_melon_collected)
			
			world_map.levels.append(level)
			
		world_maps.append(world_map)
		
		go_to_current_world_scene()
	
	save_game_file.close()

func save_game():
	var save_game_file = File.new()
	save_game_file.open(save_file_path, File.WRITE)
	
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for save_node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load
		if save_node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % save_node.name)
			continue
		
		# Check the node has a save function.
		if !save_node.has_method("get_save_data"):
			print("persistent node '%s' is missing a save() function, skipped" % save_node.name)
			continue
			
		# Call the node's save function.
		var node_data = save_node.call("get_save_data")

		# Store the save dictionary as a new line in the save file.
		save_game_file.store_line(to_json(node_data))
		
	save_game_file.close()

func get_save_data():
	var save_dict = {}
	var i = 0
	
	for world_map in world_maps:
		save_dict["world_maps_%d" % i] = world_map.get_save_data()
		i += 1
	
	return save_dict

func update_level_details(world_number, level_number, completed, total_number_of_coins):
	if world_maps == null or world_maps.size() == 0:
		return
		
	var level = world_maps[world_number].levels[level_number]
	level.completed = completed
	level.total_number_of_coins = total_number_of_coins
	
	save_game()
		
func clean_data():
	world_maps = []

# returns false and doesn't do anything if value was already in the dict
func edit_keyboard_input_value(action, ui_action, value):
	var value_physical_scancode = value.physical_scancode
	
	#check if that value has already been mapped
	if check_if_exists(input_keyboard_game_actions_dict, value_physical_scancode):
		return false
	
	input_keyboard_game_actions_dict[action] = value_physical_scancode
	
	if ui_action != null and ui_action != "":
		input_keyboard_ui_actions_dict[ui_action] = value_physical_scancode
		
	return true
	
func check_if_exists(dict, key_value):
	for key in dict:
		if dict != null and dict[key] != null:
			if dict[key] == key_value:
				return true
	
	return false
	
func edit_joypad_input_value(action, ui_action, value):
	var value_button_index = value.button_index
	
	#check if that value has already been mapped
	if check_if_exists(input_joypad_game_actions_dict, value_button_index):
		return false
	
	input_joypad_game_actions_dict[action] = value_button_index
	
	if ui_action != null and ui_action != "":
		input_joypad_ui_actions_dict[ui_action] = value_button_index
	
	return true
	
func clear_action(action):
	var action_list = InputMap.get_action_list(action)
	for event in action_list:
		InputMap.action_erase_event(action, event)

func save_input_values():
	var save_input_config_file = File.new()
	save_input_config_file.open(save_input_config_path, File.WRITE)
	
	var all_actions_list = [input_keyboard_game_actions_dict, input_keyboard_ui_actions_dict, \
							input_joypad_game_actions_dict, input_joypad_ui_actions_dict]
	
	save_input_config_file.store_line(to_json(all_actions_list))
	save_input_config_file.close()

# Loads the input values from save_input_config_path or the specified path
func load_input_values(defaults: bool = false):
	clean_all_dicts()
	
	# open file
	var save_input_config_file = File.new()
	
	var save_input_path
	if defaults:
		save_input_path = save_input_config_path_defaults
	else:
		save_input_path = save_input_config_path		
		
	# check that either the file or the default input file exists
	if not save_input_config_file.file_exists(save_input_path):
		save_input_path = save_input_config_path_defaults
		if not save_input_config_file.file_exists(save_input_path):
			return
	
	save_input_config_file.open(save_input_path, File.READ)
	var parsed_input_list = parse_json(save_input_config_file.get_line())	
	save_input_config_file.close()
	
	input_keyboard_game_actions_dict = parsed_input_list[0]
	input_keyboard_ui_actions_dict = parsed_input_list[1]
	input_joypad_game_actions_dict = parsed_input_list[2]
	input_joypad_ui_actions_dict = parsed_input_list[3]
		 
	# Map each key loaded from the settings file against the keyboard game actions
	map_keyboard_events(input_keyboard_game_actions_dict)
	map_keyboard_events(input_keyboard_ui_actions_dict)
	map_joypad_events(input_joypad_game_actions_dict)
	map_joypad_events(input_joypad_ui_actions_dict)
	
func map_keyboard_events(dict):
	var input_event_key
	for key in dict:
		input_event_key = InputEventKey.new()
		if dict[key] != null:
			input_event_key.scancode = dict[key]
		
		# clear the current action, e.g. "up"
		clear_action(key)
		
		InputMap.action_add_event(key, input_event_key)

func map_joypad_events(dict):
	var input_joy_key
	
	for key in dict:
		input_joy_key = InputEventJoypadButton.new()
		if dict[key] != null:
			input_joy_key.set_button_index(dict[key])
		
		#I'm not going to clear the actions because I did already earlier in map_keyboard_events
		
		InputMap.action_add_event(key, input_joy_key)
	
func clean_all_dicts():
	clean_dict(input_keyboard_game_actions_dict)
	clean_dict(input_keyboard_ui_actions_dict)
	clean_dict(input_joypad_game_actions_dict)
	clean_dict(input_joypad_ui_actions_dict)
	
func clean_dict(dict):
	if dict == null:
		return
		
	for key in dict:
		if dict[key] != null:
			dict[key] = -1
	
func check_100_complete(world):
	var result = world_maps[world-1].completed
	return result
	
	
