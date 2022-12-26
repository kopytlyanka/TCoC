extends Node2D

var counter = 60

func _ready():
	if Game.load():
		$Timer.start()

		


func _on_Timer_timeout():
	if counter > 0:
		counter -= 1
		$Label.text = str(counter)
	else:
		$Timer.stop()
	
