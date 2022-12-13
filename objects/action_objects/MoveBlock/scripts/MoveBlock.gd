tool
extends "res://objects/action_objects/scripts/ActionObject.gd"

export var width: int = 2
export var height: int = 2
export var positions: Array
export var move_pattern: Array
export var speed: int

var iterator: int = 0

func _ready():
	global_position = positions[move_pattern[iterator]]
	var tileMap = get_node("TileMap")
	for x in range(width):
		for y in range(-height, 0):
			tileMap.set_cell(x, y, 0)
	tileMap.update_bitmask_region(Vector2(0, 0), Vector2(width - 1, -height))

func activate():
	iterator += 1
	iterator %= len(move_pattern)
	var new_position = positions[move_pattern[iterator]]
	$Tween.remove(self, 'global_position')
	$Tween.interpolate_property(
		self, 'global_position', global_position, new_position,
		global_position.distance_to(new_position) / speed,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Tween.start()

func _load():
	._load()
	iterator = data['iterator']

func _save():
	._save()
	Game.save_data['layer%d' % layer_id][name]['iterator'] = iterator
