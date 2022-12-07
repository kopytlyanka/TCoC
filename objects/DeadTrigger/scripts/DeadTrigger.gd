extends Area2D

func _ready():
	connect("body_entered", Game.get_player(), "die")
