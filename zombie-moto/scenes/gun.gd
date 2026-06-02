extends Sprite2D

@onready var marker_2d: Marker2D = $Marker2D
const bullet = preload("res://scenes/bullet.tscn")


func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		shoot()
	
func shoot()-> void:
	var new_bullet =bullet.instantiate()
	new_bullet.global_position=marker_2d.global_position
	new_bullet.target_position =(get_global_mouse_position()-marker_2d.global_position)
	get_tree().current_scene.add_child(new_bullet)
	
