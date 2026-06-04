extends Area2D
@export var fuel_bonus=30

@export var float_speed =4
@export var float_amplitude =8
var start_y =0
var time_pass =0
func _ready() -> void:
	start_y=global_position.y
	body_entered.connect(_on_body_entered)
func _process(delta: float) -> void:
	time_pass += delta
	global_position.y =start_y + sin(time_pass *float_speed) * float_amplitude

func _on_body_entered(body):
	if body.has_method("addingthefuel") and not body.hedead:
		body.addingthefuel(fuel_bonus)
		queue_free()
