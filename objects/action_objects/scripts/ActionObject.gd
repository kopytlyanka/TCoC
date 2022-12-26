tool

extends Node2D

var ObjectInfo: Resource = preload('ObjectInfo.gd')
var layer_id: int

export(int, FLAGS, 'Receiver', 'Sender', 'Green') var types = 0 setget _set_type
const RECEIVER: int = 1
const SENDER: int = 1 << 1
const GREEN: int = 1 << 2
 
func _set_type(new_types: int) -> void:
	var was_green = is_green() 
	var was_receiver = is_receiver()
	types = new_types
	if not Engine.is_editor_hint(): return
	if was_green != is_green():
		if was_green: visually_lose_green()
		else: visually_become_green()
	if was_receiver != is_receiver():
		activate_mode = MODE.Single
	property_list_changed_notify()
	
func _set(property: String, value) -> bool:
	var set_result = true
	match property:
		'Receiver/Activate Mode':
			activate_mode = value
			if Engine.is_editor_hint():
				cycle_active_now = false
		'Receiver/Initially Active':
			cycle_active_now = value
		'Sender/Receivers List':
			receivers_list = value
			for i in receivers_list.size():
				if not receivers_list[i]:
					receivers_list[i] = ObjectInfo.new()
					receivers_list[i].resource_name = 'Object Info'	
		'Green/Green Visible':
			if value:
				visually_become_green()
			else:
				visually_lose_green()
		_:
			set_result = false
	property_list_changed_notify()
	return set_result

func _get(property: String):
	match property:
		'Receiver/Activate Mode':
			return activate_mode
		'Receiver/Initially Active':
			return cycle_active_now
		'Sender/Receivers List':
			return receivers_list
		'Green/Green Visible':
			return green_visible

func _get_property_list() -> Array:
	var property_list: Array = []
	if is_receiver():
		property_list.append({
			'name': 'Receiver/Activate Mode',
			'type': TYPE_INT,
			'hint': PROPERTY_HINT_ENUM,
			'hint_string': str(MODE).substr(1)
		})
		if activate_mode == MODE.Cycle:
			property_list.append({
				'name': 'Receiver/Initially Active',
				'type': TYPE_BOOL, 
			})
	if is_sender():
		property_list.append({
			'name': 'Sender/Receivers List',
			'type': TYPE_ARRAY, 
		})
	if is_green():
		property_list.append({
			'name': 'Green/Green Visible',
			'type': TYPE_BOOL, 
		})
	return property_list
			
#[GENERAL]
func _enter_tree():
	if not Engine.is_editor_hint():
		layer_id = Game.get_parent_layer_of(self).layer_id
		if Game.is_object_in_green_group_expansion(layer_id, name):
			add_green_type()

func _ready():
	if not Engine.is_editor_hint():
		if is_receiver(): become_receiver()
		if is_sender(): become_sender()
		if is_green(): internally_become_green()
		if is_green_visually(): visually_become_green()

func check_type(type: String) -> void:
	assert(self.call('is_%s' % type), '%s is not %s!\n(path: %s)' % [self, type, self.get_path()])	
#[GENERAL]

#[RESIVER]
enum MODE {Single, Cycle}
var activate_mode: int
var cycle_active_now: bool = false

func is_receiver() -> bool:
	return bool(types & RECEIVER)
	
func add_receiver_type() -> void:
	if not is_receiver():
		types += RECEIVER
		
func become_receiver() -> void:
	add_sender_type()
	
func receive_signal(_sender: String) -> void:
	check_type('receiver')
	if is_single_mode():
		activate()
	if is_cycle_mode():
		cycle_active_now = not cycle_active_now
		cyclically_activate()

func is_single_mode() -> bool:
	return activate_mode == MODE.Single

func is_cycle_mode() -> bool:
	return activate_mode == MODE.Cycle

func is_active_now() -> bool:
	return is_cycle_mode() and cycle_active_now
	
func activate() -> void:
	pass

func cyclically_activate() -> void:
	pass
	
#[RESIVER]

#[SENDER]
signal condition_fulfilled(name)
var receivers_list: Array

func is_sender() -> bool:
	return bool(types & SENDER)
	
func add_sender_type() -> void:
	if not is_sender():
		types += SENDER

func become_sender() -> void:
	add_sender_type()
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
var GreenParticles: Resource = preload('../assets/GreenParticles.tscn')
var green_particles: Particles2D
var green_visible: bool
var save_list: Array

func is_green() -> bool:
	return bool(types & GREEN)
		
func add_green_type() -> void:
	add_to_group('green')
	if not is_green():
		types += GREEN

func is_green_visually() -> bool:
	return green_visible

func become_green() -> void:
	internally_become_green()
	visually_become_green()

func internally_become_green() -> void:
	add_green_type()
	if Engine.is_editor_hint(): return
	if is_sender():
		if Game.has_been_built:
			if not layer_id in Game.green_group_expansion.keys():
				Game.green_group_expansion[layer_id] = []
			Game.green_group_expansion[layer_id].append(name)
		for receiver_data in receivers_list:
			var receicver: Node = Game.get_layer(receiver_data.layer_id).get_node(receiver_data.name)
			receicver.internally_become_green()
	if not Game.has_been_built: _load()

func visually_become_green() -> void:
	if not is_green_visually():
		if green_particles == null:
			green_particles = GreenParticles.instance()
		add_child(green_particles)
		green_visible = true
		
func visually_lose_green() -> void:
	if not Engine.is_editor_hint(): return
	if is_green_visually():
		green_visible = false
		remove_child(green_particles)
	
func _load() -> void:
	check_type('green')
	var layer_name: String = 'layer%d' % layer_id
	if Game.save_data.empty(): return
	if not layer_name in Game.save_data.keys(): return
	if not name in Game.save_data[layer_name].keys(): return
	var data: Dictionary = Game.save_data['layer%d' % layer_id][name]
	prints(layer_id, name, data)
	for property in save_list:
		if property in data.keys():
			set(property, data[property])
	
func _save() -> Array:
	check_type('green')
	var data: Dictionary = {}
	for property in save_list:
		data[property] = get(property)
	return ['layer%d' % layer_id, name, data]
#[GREEN]
