tool
extends "res://objects/action_objects/scripts/ActionObject.gd"

var platform_tile: Resource = preload('res://objects/action_objects/Platform/PlatformTile/PlatformTile.tscn')
export var width: int = 1
export var time: float = 1

var in_process_of_destruction: bool = false
signal destruction_started

func _enter_tree():
	self.save_list = ['in_process_of_destruction']

func _ready():	
	$Area2D.connect("body_entered", self, 'check_body')
	$Area2D.scale.x = width
	for i in range(width):
		var tile: Node2D = platform_tile.instance()
		tile.position.x += 8*i
		connect('destruction_started', tile, 'start_destroy', [time])
		add_child(tile)
		
	
func check_body(body: Node) -> void:
	if body.name != 'Player' or in_process_of_destruction: return
	in_process_of_destruction = true
	emit_signal('destruction_started')
	
func end_destroy() -> void:
	if is_sender(): send_signal()
	
