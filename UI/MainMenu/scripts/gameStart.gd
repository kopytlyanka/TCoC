extends Node

func _input(event):
	if event.is_pressed():
		Game.load()
