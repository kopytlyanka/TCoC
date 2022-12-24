tool

extends '../../scripts/ActionObject.gd'

export(int, 2, 10) var width = 2 setget set_width
export(int, 2, 10) var height = 2 setget set_height
export(PoolVector2Array) var positions
export(PoolIntArray) var move_pattern
export(float, 10, 400) var speed = 100.0

var iterator: int = 0

func set_width(value: int):
	update_tile_map_with(-1)
	width = value
	update_tile_map_with(0)

func set_height(value: int):
	update_tile_map_with(-1)
	height = value
	update_tile_map_with(0)

func _enter_tree():
	self.save_list = ['iterator']

func _ready():
	if not (move_pattern.empty() or positions.empty()):
		global_position = positions[move_pattern[iterator]]

func update_tile_map_with(id: int):
	var tile_map: TileMap = get_node("TileMap")
	for x in range(width):
		for y in range(-height, 0):
			tile_map.set_cell(x, y, id)
	tile_map.update_bitmask_region(Vector2(0, 0), Vector2(width - 1, -height))

func activate() -> void:
	iterator += 1
	iterator %= len(move_pattern)
	var new_position: Vector2 = positions[move_pattern[iterator]]
	$Tween.remove(self, 'global_position')
	$Tween.interpolate_property(
		self, 'global_position',
		global_position, new_position,
		global_position.distance_to(new_position) / speed,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
