tool

extends '../../scripts/ActionObject.gd'

var ScullBullet: Resource = preload('../ScullBullet/ScullBullet.tscn')
var perpendicular: Dictionary = {
	'sprite': preload('../assets/Perpendicular.png'),
	'collision': Quat(3.5, -5, 3.5, 3)}
var parallel: Dictionary = {
	'sprite': preload('../assets/Parallel.png'),
	'collision': Quat(4, -4, 3, 4)}

const START_POSITION = Vector2(3, -4)

export(int, 1, 20) var clip_size = 10
export(float, 10, 100) var bullet_speed = 50.0
enum DIRECTION {Perpendicular, Parallel}
export(DIRECTION) var direction: int = DIRECTION.Parallel setget _set_derection
var clip: Array = []
var delay: float = 1
var timer: Timer

func _set(property, value) -> bool:
	var _set_result = true
	match property:
		'Receiver/Shot Delay':
			delay = clamp(value, 0.2, 10)
		_: _set_result = false
	return false

func _get(property):
	if property == 'Receiver/Shot Delay':
		return delay

func _get_property_list() -> Array:
	var property_list = []
	if is_cycle_mode():
		property_list.push_front({
			'name': 'Receiver/Shot Delay',
			'type': TYPE_REAL, 
		})
	return property_list

func _set_derection(new_direction: int) -> bool:
	var set_result: bool = true
	var texture: Resource
	var collision: Quat
	direction = new_direction
	match direction:
		DIRECTION.Perpendicular:
			texture = perpendicular['sprite']
			collision = perpendicular['collision']
		DIRECTION.Parallel:
			texture = parallel['sprite']
			collision = parallel['collision']
		_: set_result = false
	$Sprite.texture = texture
	$CollisionShape2D.position = Vector2(collision.x, collision.y)
	$CollisionShape2D.scale = Vector2(collision.z, collision.w)
	return set_result

func _enter_tree():
	for _i in range(clip_size):
		var bullet: Area2D = ScullBullet.instance()
		bullet.position = START_POSITION
		bullet.speed = bullet_speed
		bullet.collision_layer = layer_id
		bullet.collision_mask = layer_id
		
		clip.append(bullet)
	if is_cycle_mode():
		timer = Timer.new()
		add_child(timer)
		timer.connect('timeout', self, 'cyclically_activate')
		self.save_list = ['cycle_active_now']
	if is_single_mode():
		self.save_list = ['clip_size']

func _ready():
	if Engine.is_editor_hint(): return
	if is_active_now():
		cyclically_activate()

func activate():
	if clip.empty(): return
	var bullet: Node2D = clip[0]
	clip.pop_front()
	add_child(bullet)

func cyclically_activate():
	if not is_active_now(): return
	activate()
	timer.set_wait_time(delay)
	timer.start()

func return_to_clip(bullet: Node2D):
	bullet.position = START_POSITION
	clip.push_back(bullet)
	call_deferred('remove_child', bullet)

#func return_to_clip_all():
#	for child in get_children():
#		if child.has_signal('already_hit'):
#			return_to_clip(child)
