extends CharacterBody2D


const SPEED = 600 
@export var player : CharacterBody2D


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if  player and not player.hedead:
		var distance =  player.global_position.x -  global_position.x
		if distance > 10:
			velocity.x=SPEED
			$AnimatedSprite2D.flip_h=false
		elif distance<-10 :
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
	if player and not player.hedead:
		var overlapping_bodies = $Area2D.get_overlapping_bodies()
		if player in overlapping_bodies:
			if $Timer.is_stopped():
				player.take_damage(1)
				$Timer.start()
		else:
			$Timer.stop()
			
	

func _on_timer_timeout():
	$Timer.stop()
