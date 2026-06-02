extends CharacterBody2D
@onready var motorsoundeffect=$"player sound"


@onready var healthline=$"../CanvasLayer/Control/ProgressBar"

@onready var fuel_amount = $"../CanvasLayer/fuel amount"
@onready var diedlabel=$"../CanvasLayer/Control/died label"
@onready var GTAredeffect=$"../CanvasLayer/Control/ColorRect"

const Maxhealth= 5

var currenthealth=   Maxhealth
var hedead   = false 
const maximumfuel =100
var currentfuel =maximumfuel
const fuel_decrease_rate =8

const SPEED= 450
const JUMP_VELOCITY= -470

func _ready():
	motorsoundeffect.play()
	if healthline:
		healthline.value = currenthealth
	if fuel_amount:
		fuel_amount.value =currentfuel

	add_to_group("players")
	
func _physics_process(delta):
	
	if hedead:
		return
	currentfuel-= fuel_decrease_rate * delta
	if fuel_amount:
		fuel_amount.value= currentfuel
	
	
	if currentfuel<=0:
		currentfuel=0
		die()
		return
	
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction* SPEED
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	for i in  range(get_slide_collision_count()):
		var collision=get_slide_collision(i)
		
		var collider=collision.get_collider()
		if collider and ("ambulance" in collider.name.to_lower()) :
				if not collider.is_queued_for_deletion():
					if collider.has_node("CollisionShape2D"):
						collider.get_node("CollisionShape2D").disabled=true
					take_damage(1)
					collider.queue_free()
				
					
					
					
					break
				
	if hedead:
		$AnimatedSprite2D.stop()
	elif velocity.x!=0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	var currentspeed=velocity.length()
	
	var maximum_moto_speed  =900
	var speedratio = clamp(currentspeed /  maximum_moto_speed, 0, 1)
	
	motorsoundeffect.pitch_scale=lerp(0.55,2.3,speedratio)
	$Camera2D.global_position.y=260








func take_damage(amount):
	currenthealth -= amount
	if healthline:
		healthline.value=currenthealth
	modulate=Color(1,0 ,0)
	await get_tree().create_timer(0.2).timeout
	modulate=Color( 1,1,1)
	if currenthealth<=  0 :
		die()
		
func addingthefuel(amount):
	currentfuel+=amount
	if currentfuel> maximumfuel:
		currentfuel=maximumfuel
	if fuel_amount:
		fuel_amount.value =currentfuel




func die() :
	hedead=true 
	set_physics_process(false)
	if diedlabel:
		diedlabel.visible=true
	
	if GTAredeffect:
		GTAredeffect.visible=true
	$Timer.start()
	
	await $Timer.timeout
	var main_loop=Engine.get_main_loop()
	
	
	
	if main_loop:
		main_loop.change_scene_to_file("res://scenes/game.tscn")


func _on_hole_body_entered(body: Node2D) -> void:
	if body.name =="player":
		body.die()
