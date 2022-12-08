extends ReferenceRect

func _ready():
	var offsets = get_parent().get_parent().position
	$CameraTrigger.connect(
		"body_entered", Game.get_camera(), 'change_limits', 
		[{
			'limit_left': margin_left + offsets.x,
			'limit_top': margin_top + offsets.y,
			'limit_right': margin_right + offsets.x,
			'limit_bottom': margin_bottom + offsets.y
		}]
	)
