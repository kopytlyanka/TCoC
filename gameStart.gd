extends Node2D

func _enter_tree():
	Game.load_data()

func _ready():
	Game.activate_UI()
	Game.add_player()
	Game.add_stage()
	Game.spawn_player()
