extends ReferenceRect

onready var offsets = Game.get_parent_layer_of(self).position + Game.get_stage().position

func _ready():
	$CameraTrigger.connect('body_entered', self, 'body_check')

func body_check(body: Node):
	if body.name != 'Player': return
	Game.get_player().motion_state = false
	Game.get_camera().change_limits(
		{
			'limit_left': margin_left + offsets.x,
			'limit_top': margin_top + offsets.y,
			'limit_right': margin_right + offsets.x,
			'limit_bottom': margin_bottom + offsets.y
		}
	)
