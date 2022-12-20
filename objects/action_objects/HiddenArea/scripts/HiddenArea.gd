tool

extends "res://objects/action_objects/scripts/ActionObject.gd"

export(float, 0, 5) var time = 0.25
var hides: bool = true
	
func _enter_tree():
	self.save_list = ['hides']
	
func activate() -> void:
	hides = false
	$Tween.interpolate_property(
		self, 'modulate:a',
		modulate.a, 0,
		time)
	$Tween.start()
