extends Camera2D

const TRANSITION = Tween.TRANS_EXPO
const EASY = Tween.EASE_IN_OUT
const BASIC_DURATION = 0.4
var duration: float  = 0

func change_limits(body: Node, new_limits: Dictionary):
	if body.name != 'Player': return
	for limit in new_limits.keys():
		$Tween.interpolate_property(
			self, limit, get(limit), new_limits[limit], duration,
			TRANSITION, EASY
		)
	$Tween.start()
	duration = BASIC_DURATION
