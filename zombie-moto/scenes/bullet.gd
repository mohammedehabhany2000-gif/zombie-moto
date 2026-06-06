extends Area2D

var speed = 650
var direction =Vector2.ZERO


func _ready() -> void:
	add_to_group("bullet")

	

func _process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position+= direction*speed*delta
	
func _on_timer_timeout() -> void:
	queue_free()
	
	
	
	


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("zombie_take_damage"):
		area.zombie_take_damage(1)
		
		
		queue_free()
