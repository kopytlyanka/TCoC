extends KinematicBody2D

const ACCELERATION: float = 450.0
const MAX_HORIZONTAL_SPEED: float = 70.0
const FRICTION: float = 0.55

const GRAVITY: Vector2 = Vector2.DOWN
const GRAVITY_POWER: float = 680.0
const MAX_FALING_SPEED: float = 190.0
const AIR_RESISTANCE: float = 0.1

const JUMP_POWER: float = 100.0
const MAX_TIME_IN_JUMP: float = 0.18
const COUNT_OF_JUMPS: int = 2
var time_in_jump: float = 0
var count_of_jumps: int = COUNT_OF_JUMPS

var velocity: Vector2 = Vector2.ZERO
var motion_state: bool = true
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		for object in $InteractArea.get_overlapping_areas():
			if object.has_method("interact"):
				object.interact()
	
func _physics_process(delta):
	if can_not_move() : return
	var x_direction: int = int(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
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

func can_not_move() -> bool:
	return not motion_state
	
func die() -> void:
	Game.save()
	get_tree().change_scene("res://UI/MainMenu/MainMenu.tscn")
