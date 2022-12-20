tool

extends "res://objects/action_objects/scripts/ActionObject.gd"

var lever_on: Resource = preload('res://objects/action_objects/Lever/assets/lever_on.png')
var lever_off: Resource = preload('res://objects/action_objects/Lever/assets/lever_off.png')
export(bool) var active = false

func _enter_tree():
	self.save_list = ['active']

func _ready():
	update_texture()

func interact() -> void:
	active = not active
	update_texture()
	send_signal()

func update_texture() -> void:
	if active: $Sprite.texture = lever_on
	else: $Sprite.texture = lever_off
