extends Node2D
class_name ActionObject

export var receiver = false
export var sender = false
export var green = false

func _ready():
	if receiver: become_receiver()
	if sender: become_sender()
	if green: become_green()

func check_type(type: String):
	assert(self.get(type), "%s is not %s!\n(path: %s)" % [self, type, self.get_path()])

#[RESIVER]
func is_receiver():
	return receiver

func become_receiver():
	if not is_receiver(): receiver = true
	
func activate():
	check_type('receiver')
#[RESIVER]

#[SENDER]
signal condition_fulliled

func is_sender():
	return sender

func become_sender():
	if not is_sender(): sender = true
	for i in get_child_count():
		var child = get_child(i)
		if child.has_method('activate'):
			connect('condition_fulliled', get_child(i), 'activate')
		
func send_signal():
	check_type('sender')
	emit_signal("condition_fulliled")
#[SENDER]

#[GREEN]
var particles = preload("res://objects/action_objects/assets/GreenParticles.tscn")

func is_green():
	return green

func become_green():
	if not is_green(): green = true
	add_child(particles.instance())
	add_to_group('green')

func save():
	check_type('green')
	
func load():
	check_type('green')
#[GREEN]
