extends Area2D
@onready var mission_panal = $"../CanvasLayer/ColorRect2"
@onready var mission_text = $"../CanvasLayer/ColorRect2/youwin"
var  player_won = false
func _ready() -> void:
	mission_panal.visible = false
	


func _on_body_entered(body):
	if body.name.to_lower().contains("player"):
		player_won= true
		mission_panal.visible = true
		mission_text.visible =true
		get_tree().paused = true
		
func _input(event):
		if player_won and event.is_action_pressed("ui_accept"):
			get_tree().paused =false
			get_tree().reload_current_scene()
		
		
