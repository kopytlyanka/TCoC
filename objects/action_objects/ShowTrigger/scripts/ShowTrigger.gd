tool
extends "res://objects/action_objects/scripts/ActionObject.gd"
		
export var time: float = 0.25
	
func activate() -> void:
	$Tween.interpolate_property(
		self, 'modulate:a',
		modulate.a, 0,
		time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
