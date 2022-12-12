tool
extends "res://objects/action_objects/scripts/ActionObject.gd"

var lever_on = preload('res://objects/action_objects/Lever/assets/lever_on.png')
var lever_off = preload('res://objects/action_objects/Lever/assets/lever_off.png')
export var active = false

func _ready():
	update_texture()

func interact():
	active = not active
	update_texture()
	send_signal()

func update_texture():
	if active: $Sprite.texture = lever_on
	else: $Sprite.texture = lever_off
 
