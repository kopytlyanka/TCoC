extends Node2D

onready var layer_id = int(name)
var convert_dictionary = {
	SPIKES : load('res://objects/Spikes/Spikes.tscn')
}
enum {SPIKES = 1}

func _ready():
	convert_to_objects_tiles(SPIKES)
	Game.layer_visibility_turned(Game.OFF, layer_id)
	Game.set_layer_collision(layer_id)

func convert_to_objects_tiles(tiles_id: int):
	var tileMap = get_node("TileMap")
	for tile in tileMap.get_used_cells_by_id(tiles_id):
		tileMap.set_cell(tile.x, tile.y, -1)
		var object = convert_dictionary[tiles_id].instance()
		object.position = tileMap.map_to_world(tile) * tileMap.scale
		add_child(object)
