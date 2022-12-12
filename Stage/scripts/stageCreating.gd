extends Node2D

func _enter_tree():
	var player = preload("res://Player/Player.tscn").instance()
	add_child(player)

func _ready():
	Game.load_data()
