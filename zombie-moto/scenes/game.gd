extends Node2D
@onready var boss_label =$CanvasLayer/boss
@onready var canvas_modulate =$CanvasModulate

func _on_boss_trigger_body_entered(body):
	if body.is_in_group("players"):
		boss_label.visible =true
		var tween = create_tween()
		tween.tween_property(canvas_modulate,"color", Color.RED, 0.8)
		
		await get_tree().create_timer(2).timeout
		boss_label.visible=false
		
func reset_screen():
	var tween = create_tween()
	tween.tween_property(canvas_modulate,"color", Color.WHITE, 1)
	
