extends Node2D

export(PackedScene) var particle_emission_scene

var previous_cell : Vector2

func _ready():
	pass

#Delete a tile from the tile map named "tile_name" in position "position"
func delete_tile(tile_name, position):
	var tile_map : TileMap
	var cell : Vector2
	
	if tile_name == $GrassTileMapModified.name:
		tile_map = $GrassTileMapModified
		#cell = tile_map.world_to_map(position)
	elif tile_name == $GrassTileMapRightSlope.name:
		tile_map = $GrassTileMapRightSlope
	elif tile_name == $GrassTileMapLeftSlope.name:
		tile_map = $GrassTileMapLeftSlope	
	else:
		return
		
	var original_position = position
	position = position.rotated(-tile_map.rotation)
	cell = tile_map.world_to_map(position)
	
	tile_map.set_cellv(cell, -1)
	
	if tile_map.rotation != 0:
		# convoluted code to fix a problem with the rotation
		for _i in range(0,100):
			if previous_cell == cell:
				position += Vector2(.5,0)
				cell = tile_map.world_to_map(position)
				tile_map.set_cellv(cell, -1)
			else:
				previous_cell = cell
#	else:
#		for _i in range(0,20):
#			if previous_cell == cell:
#				position -= Vector2(0,1)
#				cell = tile_map.world_to_map(position)
#				tile_map.set_cellv(cell, -1)
#			else:
#				previous_cell = cell
		
	emit_particles(original_position)

func emit_particles(position):
	# there is a script on the emitter that will queue it free when the emission is over
	var particle_emission = particle_emission_scene.instance()
	particle_emission.global_position = position
	get_parent().add_child(particle_emission)
