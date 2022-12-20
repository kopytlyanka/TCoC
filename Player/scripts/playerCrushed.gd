extends Area2D

func _ready():
	connect('body_entered', self, 'check_body')

func check_body(_body):
	Game.get_player().die()
