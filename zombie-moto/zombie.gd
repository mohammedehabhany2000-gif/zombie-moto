extends CharacterBody2D


const SPEED = 400

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_in :CharacterBody2D=null


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity *delta
	else :
		velocity.y =0
	var players = get_tree().get_nodes_in_group("players")
	if players.size()>0:
		var player = players[0]
		
		var distance =  player.global_position.x -  global_position.x
		
		if distance > 15:
			velocity.x=SPEED
			$AnimatedSprite2D.flip_h=false
		elif distance<-15:
			velocity.x=-SPEED
			$AnimatedSprite2D.flip_h=true
		else:
			velocity.x = 0
		if $AnimatedSprite2D.sprite_frames.has_animation("run") and velocity.x !=0:
			$AnimatedSprite2D.play("run")
		elif $AnimatedSprite2D.sprite_frames.has_animation("idle") and velocity.x ==0:
			$AnimatedSprite2D.play("idle")
	else:
		velocity.x=0
		if $AnimatedSprite2D.sprite_frames.has_animation("idle"):
			$AnimatedSprite2D.play("idle")
	move_and_slide()
	
	
	if player_in and not player_in.hedead:
		if $Timer.is_stopped():
			player_in.take_damage(1)
			$Timer.start()
			
			
			
			
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		player_in = body
func _on_area_2d_body_exited(body: Node2D)  -> void:
	if body == player_in:
		player_in=null
		$Timer.stop()
func _on_timer_timeout() -> void:
	$Timer.stop()
	
			
	
