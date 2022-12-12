extends Node

enum {OFF, ON}

#[SAVE]
var save_file: File # onready var save_file = preload(PATH: str)
var spawn_point = Vector2(1, 1) # var spawn_point: Vector2
var	visible_layer_id: int

func load():
	get_tree().change_scene("res://Stage/Stage.tscn")
	
func load_data():
# 	spawn_point = str2var(save_file['spawn_point'])
	visible_layer_id = spawn_point.x
#	var _green_group = get_tree().get_nodes_in_group('green')
#	for node in green_group:
#		node.load_data(save_file[node.name may be])
	change_display_to_layer(visible_layer_id)
	get_layer(visible_layer_id).get_node('SpawnPoint%d' % spawn_point.y).spawn_player()

func save():
	pass
#	save_file['spawn_point'] = var2str(spawn_point)
#	var _green_group = get_tree().get_nodes_in_group('green')
#	for node in green_group:
#		node.save_data(save_file[node.name may be])
#[SAVE]

#[GETTERS]
func get_stage() -> Node:
	return get_viewport().get_child(1)
	
func get_player() -> Node:
	return get_stage().get_node('Player')
	
func get_camera() -> Node:
	return get_player().get_node('Camera')

func get_layer(layer_id: int) -> Node:
	return get_stage().get_node('Layer%d' % layer_id)
	
func get_parent_layer_of(node: Node) -> Node:
	var parent = node.get_parent()
	if parent.name == 'Stage': return null
	elif parent.name.substr(0, 5) == 'Layer':
		return parent
	return get_parent_layer_of(parent)
#[GETTERS]

#[USEFUL]
func pow2(power: int) -> int:
	return 1 << power
	
func change_property(property: String, node: Node, value):
	if node.get(property) != null:
		node.set(property, value)
	for i in node.get_child_count():
		change_property(property, node.get_child(i), value)
#[USEFUL]

#[DISPLAY]
func change_display_to_layer(layer_id: int):
	if visible_layer_id: layer_visibility_turned(OFF, visible_layer_id)
	visible_layer_id = layer_id
	layer_visibility_turned(ON, visible_layer_id)
	set_player_mask(layer_id)
	
func layer_visibility_turned(state: bool, layer_id: int):
	change_property('visible', get_layer(layer_id), state)

func set_layer_collision(layer_id: int):
	change_property('collision_layer', get_layer(layer_id), pow2(layer_id - 1))
	
func set_player_mask(layer_id: int):
	change_property('collision_mask', get_player(), pow2(layer_id - 1))
#[DISPLAY]
