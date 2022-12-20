tool

extends Area2D

onready var ScullTrap = get_parent()
var speed: float

signal already_hit(bullet)

func _ready():
	connect('body_entered', self, 'check_body')
	connect('already_hit', ScullTrap, 'return_to_clip')
	
func _physics_process(delta):
	position.x += speed * delta
		
func check_body(body):
	if body == ScullTrap: return
	if body.has_method('die'):
		body.die()
	emit_signal('already_hit', self)
	
	
