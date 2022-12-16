extends Camera2D

const BASIC_DURATION: float = 0.36
var duration: float = 0

func _ready():
	$Tween.connect("tween_all_completed", Game.get_player(), 'set', ['motion_state', true])

func change_limits(new_limits: Dictionary) -> void:
	for limit in new_limits.keys():
		$Tween.interpolate_property(
			self, limit,
			get(limit), new_limits[limit],
			duration,
			Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	$Tween.start()
	duration = BASIC_DURATION

