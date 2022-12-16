extends StaticBody2D

onready var sprite: Sprite = $Sprite
onready var tween: Tween = $Sprite/Tween
onready var particles: Particles2D = $Particles2D

var SHAKES_PER_SECOND: float = 20
var FADE_OUT_TIME: float = 0.36
var shakes_count: int
var shake_time: float

signal tile_destroyed

func _ready():
	rand_seed(int(Time.get_unix_time_from_system()))
	tween.connect('tween_completed', self, 'recive_signal')
	connect('tile_destroyed', get_parent(), 'end_destroy')
	
func recive_signal(_object: Node2D, key: String) -> void:
	if key == ':position':
		shake()
	
func start_destroy(time: float) -> void:
	shakes_count = int(SHAKES_PER_SECOND * time)
	shake_time = time / shakes_count
	particles.emitting = true
	shake()

func shake() -> void:
	shakes_count -= 1
	if shakes_count > 0:
		var new_position: Vector2 = Vector2(randi()%3 - 1, randi()%3 - 1)
		tween.interpolate_property(
			sprite, 'position', sprite.position, new_position, shake_time
		)
		tween.start()
	else:
		fade_out()
		
func fade_out():
	collision_layer = 0
	particles.emitting = false
	particles.modulate.a = 0
	tween.interpolate_property(
		sprite, 'position:y',
		sprite.position.y, sprite.position.y + 10,
		FADE_OUT_TIME)
	tween.interpolate_property(
		sprite, 'modulate:a',
		sprite.modulate.a, 0,
		FADE_OUT_TIME)
	tween.start()
	emit_signal('tile_destroyed')
