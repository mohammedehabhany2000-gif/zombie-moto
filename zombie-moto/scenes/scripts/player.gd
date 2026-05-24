extends CharacterBody2D
@onready var motocycle_sound=$"player sound"
func _ready():
	motocycle_sound.play()


const SPEED = 900.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	var current_speed = velocity.length()
	var maximum_moto_speed = 900
	var speed_ratio = clamp(current_speed / maximum_moto_speed, 0, 1)
	motocycle_sound.pitch_scale = lerp(0.55,2.3,speed_ratio)
	$Camera2D.global_position.y = 260
	
	
