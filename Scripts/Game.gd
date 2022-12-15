extends Node

#[SAVE/LOAD]
var save_file = File.new()
var save_file_name: String
var save_data: Dictionary
var spawn_point: Vector2
var visible_layer_id: int
var green_group_expansion: Dictionary

func load():
	if save_file.file_exists('user://save/save1.json'):
		save_file_name = 'save1'
	else:
		save_file_name = 'base_save'
	get_tree().change_scene('res://GamePlay.tscn')
	
func load_data():
	save_file.open('user://save/%s.json' % save_file_name, File.READ)
	save_data = parse_json(save_file.get_as_text())
	green_group_expansion = save_data['green_group_expansion']
	spawn_point = str2var(save_data['spawn_point'])
	visible_layer_id = int(spawn_point.x)
	save_file.close()

func save():
	if save_file_name == 'base_save':
		save_file_name = 'save1'
	save_file.open('user://save/%s.json' % save_file_name, File.WRITE)
	for object in get_tree().get_nodes_in_group('green'):
		var object_data: Array = object._save()
		var object_layer: String = object_data[0]
		var object_name: String = object_data[1]
		var object_properties: Dictionary = object_data[2]
		if not object_layer in save_data.keys():
			save_data[object_layer] = {}
		save_data[object_layer][object_name] = object_properties
	save_data['green_group_expansion'] = green_group_expansion
	save_data['spawn_point'] = var2str(spawn_point)
	save_file.store_string(to_json(save_data))
	save_file.close()
#[SAVE/LOAD]

#[GETTERS]
func get_self() -> Node:
	return get_viewport().get_node_or_null('GamePlay')

func get_stage() -> Node:
	return Game.get_self().get_node_or_null('Stage')
	
func get_player() -> Node:
	return Game.get_self().get_node_or_null('Player')
	
func get_camera() -> Node:
	return get_player().get_node('Camera')

func get_layer(layer_id: int) -> Node:
	return get_stage().get_node_or_null('Layer%d' % layer_id)
	
func get_parent_layer_of(node: Node) -> Node2D:
	var parent = node.get_parent()
	if parent.name == 'Stage': return null
	elif parent.name.substr(0, 5) == 'Layer':
		return parent
	return get_parent_layer_of(parent)
#[GETTERS]

#[USEFUL]
func pow2(power: int) -> int:
	return 1 << power
	
func change_property(property: String, node: Node, value) -> void:
	if node.get(property) != null:
		node.set(property, value)
	for i in node.get_child_count():
		change_property(property, node.get_child(i), value)
#[USEFUL]

#[DISPLAY]
enum {OFF, ON}

func change_display_to_layer(layer_id: int) -> void:
	layer_visibility_turned(OFF, visible_layer_id)
	visible_layer_id = layer_id
	layer_visibility_turned(ON, visible_layer_id)
	set_player_mask(layer_id)
	
func layer_visibility_turned(state: bool, layer_id: int) -> void:
	change_property('visible', get_layer(layer_id), state)

func set_layer_collision(layer_id: int) -> void:
	change_property('collision_layer', get_layer(layer_id), pow2(layer_id - 1))
	
func set_player_mask(layer_id: int) -> void:
	change_property('collision_mask', get_player(), pow2(layer_id - 1))
#[DISPLAY]

#[CREATING]
var has_been_built: bool

func activate_UI() -> void:
	#some shit
	pass

func add_player() -> void:
	Game.get_self().add_child(preload("res://Player/Player.tscn").instance())

func add_stage() -> void:
	get_self().add_child(preload("res://Stage/Stage.tscn").instance())

func spawn_player() -> void:
	get_layer(visible_layer_id).get_node('SpawnPoint%d' % spawn_point.y).spawn_player()
	change_display_to_layer(visible_layer_id)
	
func get_data_about_layer(layer_name: String) -> Dictionary:
	if layer_name in save_data.keys():
		return save_data[layer_name]
	return {}

func is_object_in_green_group_expansion(layer_id: int, name: String) -> bool:
	if layer_id in Game.green_group_expansion.keys():
		if name in Game.green_group_expansion[layer_id].keys():
			return true
	return false
#[CREATING]
