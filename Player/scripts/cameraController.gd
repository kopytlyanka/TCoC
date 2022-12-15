extends Camera2D

const TRANSITION = Tween.TRANS_EXPO
const EASY = Tween.EASE_IN_OUT
const BASIC_DURATION: float = 0.32
var duration = 0

func _ready():
	$Tween.connect("tween_all_completed", Game.get_player(), 'set', ['motion_state', true])

func change_limits(new_limits: Dictionary):
	for limit in new_limits.keys():
		$Tween.interpolate_property(
			self, limit, get(limit), new_limits[limit], duration,
			TRANSITION, EASY
		)
	$Tween.start()
	duration = BASIC_DURATION

