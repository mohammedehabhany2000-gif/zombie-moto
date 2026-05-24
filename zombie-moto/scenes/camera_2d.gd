extends Camera2D

@export var player: CharacterBody2D
func _process(delta):
	if player:
		global_position.x = player.global_position.x
