extends Node2D

func _enter_tree():
	Game.has_been_built = false

func _ready():
	for layer_id in Game.green_group_expansion.keys():
		var layer: Node2D = Game.get_layer(layer_id)
		for object_name in Game.green_group_expansion[layer_id]:
			layer.get_node(object_name).become_green()
	Game.has_been_built = true
	Game.save_data = {}
