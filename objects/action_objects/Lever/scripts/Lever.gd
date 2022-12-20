tool

extends '../../scripts/ActionObject.gd'

var lever_on: Resource = preload('res://objects/action_objects/Lever/assets/lever_on.png')
var lever_off: Resource = preload('res://objects/action_objects/Lever/assets/lever_off.png')
export(bool) var active = false setget update_texture

func _enter_tree():
	self.save_list = ['active']

func interact() -> void:
	update_texture(not active)
	send_signal()

func update_texture(new_active: bool) -> void:
	active = new_active
	if active: $Sprite.texture = lever_on
	else: $Sprite.texture = lever_off
