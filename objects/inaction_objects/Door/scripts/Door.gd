extends Area2D

export var layer_id: int

func interact() -> void:
	if layer_id > 0:
		Game.change_display_to_layer(layer_id)
