extends KinematicBody2D

const ACCELERATION = 450
const MAX_HORIZONTAL_SPEED = 70
const FRICTION = 0.5

const GRAVITY = Vector2.DOWN
const GRAVITY_POWER = 680
const MAX_FALING_SPEED = 190
const AIR_RESISTANCE = 0.1

const JUMP_POWER = 100
const MAX_TIME_IN_JUMP = 0.18
const COUNT_OF_JUMPS = 2
var time_in_jump = 0
var count_of_jumps = COUNT_OF_JUMPS

var velocity = Vector2.ZERO
	
func _ready():
	$RigidArea.connect("body_entered", self, 'die')
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		for object in $InteractArea.get_overlapping_areas():
			if object.has_method("interact"):
				object.interact()
	
func _physics_process(delta):
	var x_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x += x_direction * ACCELERATION * delta
	
	if is_on_floor():
		count_of_jumps = COUNT_OF_JUMPS
		time_in_jump = 0
		if x_direction == 0:
			velocity.x = lerp(velocity.x, 0, FRICTION)
	elif x_direction == 0:
			velocity.x = lerp(velocity.x, 0, AIR_RESISTANCE)
	
	if is_on_ceiling():
		time_in_jump = MAX_TIME_IN_JUMP
	
	velocity += GRAVITY * GRAVITY_POWER * delta		
	if Input.is_action_just_pressed("ui_up"):
		count_of_jumps -= 1
		time_in_jump = 0
		if count_of_jumps > 0:
			velocity.y = -JUMP_POWER
	if Input.is_action_pressed("ui_up") and count_of_jumps >= 0 and not is_on_floor():
		if time_in_jump < MAX_TIME_IN_JUMP:
			velocity.y = -JUMP_POWER
			time_in_jump += delta
			velocity.y *= abs(sin(velocity.angle_to(Vector2.RIGHT)))
	
	velocity.x = clamp(velocity.x, -MAX_HORIZONTAL_SPEED, MAX_HORIZONTAL_SPEED)
	velocity.y = clamp(velocity.y, -JUMP_POWER, MAX_FALING_SPEED)
	velocity = move_and_slide(velocity, Vector2.UP)

func die(_body):
	Game.save()
	get_tree().change_scene("res://UI/MainMenu/MainMenu.tscn")
