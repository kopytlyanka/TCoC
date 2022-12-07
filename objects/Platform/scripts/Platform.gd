extends Area2D

var platformtile = load('res://objects/Spikes/Spikes.tscn')

func _ready():
	connect("body_entered", self, 'debug')
	var platform_tile = platformtile.instance()
	platform_tile.position = position
	add_child(platform_tile)
	
func _process(delta):
	print(get_child(1), get_child(1).position)
	
func debug(body: Node):
	if body.name != 'Player': return
	Game.change_property('collision_layer', self, 0)
	Game.change_property('visible', self, false)
