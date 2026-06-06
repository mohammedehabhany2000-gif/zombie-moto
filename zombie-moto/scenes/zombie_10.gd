extends CharacterBody2D
@onready var zombie_soundeffect=$AudioStreamPlayer2D
@onready var damage_time = $Timer
@onready var health_bar =$ProgressBar

@onready var detection_area = $detiction
@onready var damage_area = $"damage area"
const speed =160
var health =20
var is_dead =false
var is_live = false





var player_in = null
var player_touching=false

func _ready():
	visible =true
	is_live=false
	is_dead=false
	health= 7
	get_tree().paused= false
	
	if has_node("AnimatedSprite2D") and$AnimatedSprite2D.sprite_frames.has_animation("default"):
		$AnimatedSprite2D.play("default")
	if has_node("ProgressBar"):
		health_bar.max_value = health
		health_bar.value=health
	
	if has_node("Timer") and not $Timer.timeout.is_connected(_on_damage_time_timeout):
		$Timer.timeout.connect(_on_damage_time_timeout)
	if not detection_area.body_entered.is_connected(_on_detection_body_entered):
		detection_area.body_entered.connect(_on_detection_body_entered)
	if not damage_area.body_entered.is_connected(_on_damage_area_body_entered):
		damage_area.body_entered.connect(_on_damage_area_body_entered)
	if not damage_area.area_entered.is_connected(_on_damage_area_area_entered):
		damage_area.area_entered.connect(_on_damage_area_area_entered)
	if not damage_area.body_exited.is_connected(_on_damage_area_body_exited):
		damage_area.body_exited.connect(_on_damage_area_body_exited)
	
	


func _process(delta: float) -> void:
	if is_dead:
		return
		
	if is_live:
		velocity.x = -speed
		move_and_slide() 
		
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.flip_h=true
			if $AnimatedSprite2D.sprite_frames.has_animation("run"):
				$AnimatedSprite2D.play("run")
	else:
		velocity.x =0
		move_and_slide()

func _on_detection_body_entered(body: Node2D) -> void:
	
	if is_dead :return
	
	
	if body.name.to_lower().contains("player") and not body.hedead:
			
			
			
			if not is_live:
				is_live= true
				if has_node("AudioStreamPlayer2D") and not zombie_soundeffect.playing:
						zombie_soundeffect.play()
			
				
func _on_damage_area_body_entered(body: Node2D) -> void:
	if is_dead :return
	
	
	if body.name.to_lower().contains("player") and not body.hedead:
		player_in = body
		player_touching= true
		body.take_damage(1)
		damage_time.start()
	elif body.name.to_lower().contains("bullet"):
		zombie_take_damage(1)
		if body.has_method("queue_free"):
			body.queue_free()
			
func _on_damage_area_body_exited(body: Node2D) -> void:
	if body ==player_in:
		player_in =null
		player_touching=false
		
		damage_time.stop()

		





	
func _on_damage_time_timeout() -> void:
	if player_in and not player_in.hedead:
		player_in.take_damage(1)
	else:
		damage_time.stop()
		
func zombie_take_damage(amount:int) -> void:
	if is_dead:return
	health -= amount
	if has_node("ProgressBar"):
		health_bar.value= health
	if health <= 0:
		die()
func die() -> void:
	is_dead =true
	is_live= false
	if has_node("AudioStreamPlayer2D"):
		zombie_soundeffect.stop()
	
	if has_node("ProgressBar"):
		health_bar.visible = false
	
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.stop()
	
	
	detection_area.set_deferred("monitoring", false)
	damage_area.set_deferred("monitoring",false)
	$CollisionShape2D.set_deferred("disabled",true)
	damage_time.stop()
	
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("death")
		await $AnimationPlayer.animation_finished
	
	get_parent().reset_screen()
	queue_free()
func _on_damage_area_area_entered(area: Area2D) -> void:
	if is_dead:
		return

	if area.is_in_group("bullet"):
		zombie_take_damage(1)
		area.queue_free()
