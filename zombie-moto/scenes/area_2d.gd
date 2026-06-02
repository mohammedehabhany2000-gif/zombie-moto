extends Area2D

@onready var damage_time = $Timer
@onready var health_bar =$ProgressBar
const speed =250
var health =20
var is_dead =false
var is_live = false





var player_in = null

func _ready():
	visible =true
	is_live=false
	if has_node("AnimatedSprite2D") and$AnimatedSprite2D.sprite_frames.has_animation("default"):
		$AnimatedSprite2D.play("default")
	if has_node("ProgressBar"):
		health_bar.max_value = health
		health_bar.value=health
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	damage_time.timeout.connect(_on_damage_time_timeout)
func _process(delta: float) -> void:
	if is_dead:
		return
		
	if is_live:
		position.x -= speed *delta
		
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.flip_h=true
			if $AnimatedSprite2D.sprite_frames.has_animation("run"):
				$AnimatedSprite2D.play("run")



func _on_body_entered(body):
	if is_dead :return
	
	
	
	if body.name.to_lower().contains("player") or body.has_method("take_damage"):
		if not body.hedead:
			
			is_live= true
			
			player_in = body
			body.take_damage(1)
			damage_time.start()
func _on_body_exited(body):
	if body ==player_in:
		player_in =null
		damage_time.stop()

		





	
func _on_damage_time_timeout() -> void:
	if player_in and not player_in.hedead:
		player_in.take_damage(1)
		
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
	if has_node("ProgressBar"):
		health_bar.visible = false
	
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.stop()
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	damage_time.stop()
	
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("death")
		await $AnimationPlayer.animation_finished
		queue_free()
