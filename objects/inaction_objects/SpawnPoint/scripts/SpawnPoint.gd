extends Node2D

func _ready():
	$Area2D.connect('body_entered', self, 'update_global_spawn_point')
	
func update_global_spawn_point(body: Node):
	if body.name != 'Player': return
	Game.spawn_point = Vector2(Game.get_parent_layer_of(self).layer_id, int(name))

func spawn_player() -> void:
	var player = Game.get_player()
	player.global_position = global_position + Vector2(0, -2)
	player.z_index = 0
