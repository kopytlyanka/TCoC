extends Node2D

func _enter_tree():
	Game.has_been_built = false

func _ready():
	Game.has_been_built = true
	Game.save_data = {}
