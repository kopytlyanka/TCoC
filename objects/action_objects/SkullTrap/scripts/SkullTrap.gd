tool

extends '../../scripts/ActionObject.gd'

var ScullBullet: Resource = preload('../ScullBullet/ScullBullet.tscn')

const START_POSITION = Vector2(3, -4)

export(int, 1, 20) var clip_size = 10
export(float, 0.2, 10) var shots_delay = 1.2
export(float, 10, 100) var bullet_speed = 40.0
var clip: Array = []

func _enter_tree():
	for _i in range(clip_size):
		var bullet: Node2D = ScullBullet.instance()
		bullet.position = START_POSITION
		bullet.speed = bullet_speed
		clip.append(bullet)
		
func _input(event):
	if event.is_action_pressed('ui_focus_next'):
		if clip.empty(): return
		var bullet: Node2D = clip[0]
		clip.pop_front()
		add_child(bullet)

func return_to_clip(bullet: Node2D):
	bullet.position = START_POSITION
	clip.push_back(bullet)
	call_deferred('remove_child', bullet)
