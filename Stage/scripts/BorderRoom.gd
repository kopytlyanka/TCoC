extends ReferenceRect

func _ready():
	var offsets = Game.get_parent_layer_of(self).position + Game.get_stage().position
	$CameraTrigger.connect(
		"body_entered", Game.get_camera(), 'change_limits', 
		[{
			'limit_left': margin_left + offsets.x,
			'limit_top': margin_top + offsets.y,
			'limit_right': margin_right + offsets.x,
			'limit_bottom': margin_bottom + offsets.y
		}]
	)
