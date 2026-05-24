extends Node2D
const ambulance_scene = preload("res://scenes/ambulance.tscn")
@export var player: CharacterBody2D
@onready var timer = $Timer
func _ready():
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()
func _on_timer_timeout():
	if player:
		var ambulance = ambulance_scene.instantiate()
		var spawn_x = global_position.x +100
		var spawn_y = 300
		ambulance.global_position = Vector2(spawn_x,spawn_y)
		get_tree().current_scene.add_child(ambulance)
	
