extends Node2D
class_name ActionObject

export var receiver: bool = false
export var sender: bool = false
export var green: bool = false
var green_visible: bool = false

export var senders_list: Array
export var receivers_list: Array

func _enter_tree():
	if is_green(): green_visible = true

func _ready():
	if receiver: become_receiver()
	if sender: become_sender()
	if green: become_green()

func check_type(type: String) -> void:
	assert(self.get(type), "%s is not %s!\n(path: %s)" % [self, type, self.get_path()])

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
	for obj in receivers_list:
		var receicver_obj = Game.get_layer(obj[0]).get_node(obj[1])
		connect('condition_fulfilled', receicver_obj, 'receive_signal')
		if is_green(): receicver_obj.hidden_become_green()

func send_signal() -> void:
	check_type('sender')
	emit_signal("condition_fulfilled", name)	
#[SENDER]

#[GREEN]
var particles = preload("res://objects/action_objects/assets/GreenParticles.tscn")

func is_green() -> bool:
	return green

func is_green_visually() -> bool:
	return green_visible

func become_green() -> void:
	hidden_become_green()
	visually_become_green()

func hidden_become_green() -> void:
	if not is_green(): green = true
	add_to_group('green')
	
func visually_become_green():
	if is_green_visually():
		add_child(particles.instance())

func save() -> void:
	check_type('green')
	
func load() -> void:
	check_type('green')
#[GREEN]
