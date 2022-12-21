tool

extends '../../scripts/ActionObject.gd'

var LeverOn: Resource = preload('../assets/LeverOn.png')
var LeverOff: Resource = preload('../assets/LeverOff.png')
export(bool) var active = false setget update_texture

func _enter_tree():
	self.save_list = ['active']

func interact() -> void:
	update_texture(not active)
	send_signal()

func update_texture(new_active: bool) -> void:
	active = new_active
	if active: $Sprite.texture = LeverOn
	else: $Sprite.texture = LeverOff
