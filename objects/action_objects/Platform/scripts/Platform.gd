tool

extends '../../scripts/ActionObject.gd'

var PlatformTile: Resource = preload('../PlatformTile/PlatformTile.tscn')

export(int, 1, 100) var width = 1 setget set_width
export(float, 0, 10) var time = 1.0

var in_process_of_destruction: bool = false
signal destruction_started

func set_width(value):
	for child in get_children():
		if child.name != 'Area2D':
			child.queue_free()
	width = value
	$Area2D.scale.x = width
	for i in range(width):
		var tile: Node2D = PlatformTile.instance()
		tile.position.x += 8*i
		connect('destruction_started', tile, 'start_destroy', [time])
		add_child(tile)

func _enter_tree():
	self.save_list = ['in_process_of_destruction']

func _ready():	
	$Area2D.connect("body_entered", self, 'check_body')
		
func check_body(body: Node) -> void:
	if body.name != 'Player' or in_process_of_destruction: return
	in_process_of_destruction = true
	emit_signal('destruction_started')
	
func end_destroy() -> void:
	if is_sender(): send_signal()
