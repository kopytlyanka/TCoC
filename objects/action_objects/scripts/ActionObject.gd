tool
extends Node2D
var ObjectInfo = preload('ObjectInfo.gd')

export(bool) var receiver = false setget , is_receiver
export(bool) var sender = false setget , is_sender
export(bool) var green = false setget , is_green
var green_visible: bool = false setget , is_green_visually
var layer_id: int

export(Array, Resource) var receivers_list setget set_receivers_list

func set_receivers_list(value):
	receivers_list = value
	for i in receivers_list.size():
		if not receivers_list[i]:
			receivers_list[i] = ObjectInfo.new()
			receivers_list[i].resource_name = 'Object Info'	
			
#[GENERAL]
func _enter_tree():
	if not Engine.is_editor_hint():
		layer_id = Game.get_parent_layer_of(self).layer_id
		if not is_green():
			green = Game.is_object_in_green_group_expansion(layer_id, name)
	if is_green(): green_visible = true

func _ready():
	if not Engine.is_editor_hint():
		if receiver: become_receiver()
		if sender: become_sender()
	if green: become_green()

func check_type(type: String) -> void:
	assert(self.get(type), "%s is not %s!\n(path: %s)" % [self, type, self.get_path()])
#[GENERAL]

#[RESIVER]
func is_receiver() -> bool:
	return receiver

func become_receiver() -> void:
	if not is_receiver(): receiver = true
	
func receive_signal(_sender: String) -> void:
	check_type('receiver')
	activate()
	
func activate() -> void:
	pass
#[RESIVER]

#[SENDER]
signal condition_fulfilled(name)

func is_sender() -> bool:
	return sender

func become_sender() -> void:
	if not is_sender(): sender = true
	for receiver_data in receivers_list:
		var receiver_layer_id: int = receiver_data.layer_id
		var receiver_name: String = receiver_data.name
		var receicver: Node = Game.get_layer(receiver_layer_id).get_node(receiver_name)
		connect('condition_fulfilled', receicver, 'receive_signal')

func send_signal() -> void:
	check_type('sender')
	emit_signal("condition_fulfilled", name)	
#[SENDER]

#[GREEN]
var particles = preload("res://objects/action_objects/assets/GreenParticles.tscn")
var save_list: Array

func is_green() -> bool:
	return green

func is_green_visually() -> bool:
	return green_visible

func become_green() -> void:
	if not Engine.is_editor_hint():
		hidden_become_green()
	visually_become_green()

func hidden_become_green() -> void:
	if not is_green(): green = true
	add_to_group('green')
	if is_sender():
		if Game.has_been_built:
			if not layer_id in Game.green_group_expansion.keys():
				Game.green_group_expansion[layer_id] = []
			Game.green_group_expansion[layer_id].append(name)
		for receiver_data in receivers_list:
			var receicver: Node = Game.get_layer(receiver_data.layer_id).get_node(receiver_data.name)
			receicver.hidden_become_green()
	if not Game.has_been_built: _load()
	
func visually_become_green() -> void:
	if is_green_visually():
		add_child(particles.instance())
	
func _load() -> void:
	check_type('green')
	var layer_name: String = 'layer%d' % layer_id
	if Game.save_data.empty(): return
	if not layer_name in Game.save_data.keys(): return
	if not name in Game.save_data[layer_name].keys(): return
	var data: Dictionary = Game.save_data['layer%d' % layer_id][name]
	for property in save_list:
		set(property, data[property])
	
func _save() -> Array:
	check_type('green')
	var data: Dictionary = {}
	for property in save_list:
		data[property] = get(property)
	return ['layer%d' % layer_id, name, data]
#[GREEN]
