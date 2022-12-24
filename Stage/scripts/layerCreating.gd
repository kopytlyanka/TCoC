extends Node2D

enum {SPIKES = 1}
var convert_dictionary: Dictionary = {
	SPIKES : preload('res://objects/inaction_objects/Spikes/Spikes.tscn')
}

onready var tile_map: TileMap = $TileMap
var layer_id: int

func _enter_tree():
	layer_id = int(name)	

func _ready():
	convert_to_objects_tiles(SPIKES)
	Game.layer_visibility_turned(Game.OFF, layer_id)
	Game.set_layer_collision(layer_id)

func convert_to_objects_tiles(tiles_id: int) -> void:
	for tile in tile_map.get_used_cells_by_id(tiles_id):
		var object: Node2D = convert_dictionary[tiles_id].instance()
		object.position = tile_map.map_to_world(tile) * tile_map.scale + Vector2(8, 8)

		var x_flipped: bool = tile_map.is_cell_x_flipped(tile.x, tile.y)
		var y_flipped: bool = tile_map.is_cell_y_flipped(tile.x, tile.y)
		var transposed: bool = tile_map.is_cell_transposed(tile.x, tile.y)

		if transposed:
			object.rotation_degrees -= 90
			if x_flipped:
				object.rotation_degrees += 180
		if not transposed and y_flipped:
			object.rotation_degrees += 180
		if transposed == (x_flipped == y_flipped):
			object.scale.x *= -1

		tile_map.set_cellv(tile, -1)
		add_child(object)
