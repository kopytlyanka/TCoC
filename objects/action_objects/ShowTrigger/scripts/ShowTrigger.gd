tool
extends "res://objects/action_objects/scripts/ActionObject.gd"
	
const TRANSITION = Tween.TRANS_LINEAR
const EASY = Tween.EASE_IN_OUT	
export var time: float = 0.2	
export var delay: float = 0
	
func activate() -> void:
	$Tween.interpolate_property(
		self, 'modulate:a', modulate.a, 0, time,
		TRANSITION, EASY, delay
	)
	$Tween.start()
