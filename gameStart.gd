extends Node2D

func _enter_tree():
	Game.load_data()

func _ready():
	Game.add_player()
	Game.add_stage()
	Game.spawn_player()
	Game.activate_UI()
