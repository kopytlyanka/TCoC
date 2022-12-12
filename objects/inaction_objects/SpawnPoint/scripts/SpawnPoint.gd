extends Node2D

onready var spawn_point_id = int(name)

func _ready():
	$Area2D.connect('body_entered', self, 'update_global_spawn_point')
	
func update_global_spawn_point(body: Node):
	if body.name != 'Player': return
	Game.spawn_point = Vector2(get_parent().layer_id, spawn_point_id)

func spawn_player() -> void:
	var player = Game.get_player()
	player.global_position = global_position + Vector2(0, -2)
	player.visible = true
