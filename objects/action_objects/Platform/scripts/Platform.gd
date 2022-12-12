tool
extends "res://objects/action_objects/scripts/ActionObject.gd"

var platform_tile = preload('res://objects/action_objects/Platform/PlatformTile/PlatformTile.tscn')
export var width: int = 1

func _ready():	
	$Area2D.connect("body_entered", self, 'destroy')
	$Area2D.scale.x = width
	$StaticBody2D.scale.x = width
	for i in range(width):
		var tile = platform_tile.instance()
		tile.position.x += 8*i
		add_child(tile)
	
func destroy(body: Node):
	if body.name != 'Player': return
	
	Game.change_property('collision_layer', self, 0)
	Game.change_property('visible', self, false)
