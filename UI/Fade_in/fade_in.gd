extends ColorRect

signal fade_finished

func fade_in():
	$AnimationPlayer.play("fade_in")

func _on_AnimationPlayer_animation_finished():
	emit_signal("fade_finished")
