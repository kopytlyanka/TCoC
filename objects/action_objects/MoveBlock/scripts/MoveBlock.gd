tool

extends "res://objects/action_objects/scripts/ActionObject.gd"

export(int, 2, 100) var width = 2
export(int, 2, 100) var height = 2
export(PoolVector2Array) var positions
export(PoolIntArray) var move_pattern
export(float, 10, 400) var speed = 100.0

var iterator: int = 0

func _enter_tree():
	self.save_list = ['iterator']

func _ready():
	global_position = positions[move_pattern[iterator]]
	var tileMap: TileMap = get_node("TileMap")
	for x in range(width):
		for y in range(-height, 0):
			tileMap.set_cell(x, y, 0)
	tileMap.update_bitmask_region(Vector2(0, 0), Vector2(width - 1, -height))

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
