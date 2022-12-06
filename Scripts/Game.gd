extends Node

enum {OFF, ON}

#[SAVE]
var save_file: File # onready var save_file = preload(PATH: str)
var	visible_layer_id: int

func load():
	get_tree().change_scene("res://stages/Stage.tscn")
	
func load_data():
	visible_layer_id = 1
	var _green_group = get_tree().get_nodes_in_group('green')
#	for node in green_group:
#		node.load_data(save_file[node.name may be])
	change_display_to_layer(visible_layer_id)
	get_player().spawn()

func save():
#	save_file['start_layer_id'] = start_layer_id
#	save_file['start_room_id'] = start_room_id
	var _green_group = get_tree().get_nodes_in_group('green')
#	for node in green_group:
#		node.save_data(save_file[node.name may be])
#[SAVE]

#[GETTERS]
func get_player():
	return get_viewport().get_child(1).get_node('Player')
	
func get_camera():
	return get_player().get_node('Camera')

func get_layer(layer_id: int):
	return get_viewport().get_child(1).get_node('Layer%d' % layer_id)
#[GETTERS]

#[DISPLAY]
func change_display_to_layer(layer_id: int):
	if visible_layer_id: layer_visibility_turned(OFF, visible_layer_id)
	visible_layer_id = layer_id
	layer_visibility_turned(ON, visible_layer_id)
	set_player_mask(int(pow(2, layer_id - 1)))
	
func layer_visibility_turned(state: bool, layer_id: int):
	change_property('visible', get_layer(layer_id), state)

func set_layer_collision(layer_id):
	change_property('collision_layer', get_layer(layer_id), int(pow(2, layer_id - 1)))
	
func set_player_mask(mask: int):
	change_property('collision_mask', get_player(), mask)
	
func change_property(property: String, node: Node, value):
	if node.get(property) != null:
		node.set(property, value)
	for i in node.get_child_count():
		change_property(property, node.get_child(i), value)
#[DISPLAY]
