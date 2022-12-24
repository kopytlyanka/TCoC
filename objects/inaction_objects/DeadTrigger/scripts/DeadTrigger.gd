extends Area2D

func _ready():
	connect('body_entered', self, 'check_body')

func check_body(body: Node2D):
	if body.has_method('die'):
		body.die()
