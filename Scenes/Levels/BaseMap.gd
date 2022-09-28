extends Node2D

export var world_number = 1

func _ready():
	var index = world_number - 1
		
	if GameManager.world_maps == null or GameManager.world_maps.size() == 0:
		return
		
	if GameManager.world_maps[index].levels[0].completed:
		var map_level = get_node("MapLevel_0")
		map_level.allow_direction_right = true
		map_level.modulate = Color(.36, .87 , 0)
		
	if GameManager.world_maps[index].levels[1].completed:
		var map_level = get_node("MapLevel_1")
		map_level.allow_direction_right = true
		map_level.modulate = Color(.36, .87 , 0)
	
	if GameManager.world_maps[index].levels[2].completed:
		var map_level = get_node("MapLevel_2")
		map_level.allow_direction_down = true
		map_level.modulate = Color(.36, .87 , 0)
	
	if GameManager.world_maps[index].levels[3].completed:
		var map_level = get_node("MapLevel_3")
		map_level.allow_direction_left = true
		map_level.modulate = Color(.36, .87 , 0)
	
	if GameManager.world_maps[index].levels[4].completed:
		var map_level = get_node("MapLevel_4")
		map_level.allow_direction_left = true
		map_level.modulate = Color(.36, .87 , 0)	
		
func update_ui(level_number):
	$CanvasLayer/Header.text = \
		("World %s - Level %s" % [world_number, level_number])
	var level = GameManager.world_maps[world_number-1].levels[level_number-1]
	
	if level.completed:
		var water_melon_collected_str = "No"
		if level.water_melon_collected:
			water_melon_collected_str = "Yes"
			
		$CanvasLayer/SubHeader.text = "Coins %d/%d \nWatermelon: %s" \
			% [level.number_of_collected_coins, level.total_number_of_coins, water_melon_collected_str]
	else:
		$CanvasLayer/SubHeader.text = ""
