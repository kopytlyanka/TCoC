extends Node2D

export var green = false

func _ready():
	if green: become_green()

func become_green():
	add_child(preload("res://objects/green_objets/GreenParticles.tscn").instance())
	add_to_group('green')
