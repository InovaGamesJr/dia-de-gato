extends CharacterBody2D

@onready var centrodoplayer = get_parent().get_node("player/boneco/centro_gato")
enum states {wait, idle, fling, waves, chase, position_chase}
var state = states.wait
var ondas = preload("res://scenes/ondas.tscn")
var fling_speed : int = -120
var speed : int = 200
var initial_position : Vector2 = Vector2(726, 440)
var direction : int = 1
var player_position : Vector2
var numero_random

func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	state = states.idle

func _process(delta: float) -> void:
	pass
func _physics_process(delta):
	match state:
		states.wait:
			pass
		states.idle:
			idle()
		states.fling:
			fling()
		states.waves:
			waves()
		states.chase:
			chase()
		states.position_chase:
			position_chase()
	
	move_and_slide()
	
func idle():
	#O objetivo aqui é ele sempre voltar pra sua posição inicial após um chase no player
	var tween = create_tween()
	tween.tween_property($".", "global_position", Vector2(726, 440), 2)
	await get_tree().create_timer(3.0).timeout
	state = states.fling
	

func fling():
	velocity.y = fling_speed
	if position.y <= 250:
		velocity.y = 0
		$"timer para onda".start()
		numero_random = randi_range(1,3)
		state = states.waves

func waves():
	await get_tree().create_timer(7.0).timeout
	$"timer para onda".stop()
	if $"timer para onda".is_stopped():
		if numero_random == 1:
			direction = 1
		if numero_random == 2:
			direction = -1
		state = states.position_chase
	

func position_chase():
	velocity.x = direction * 200
	if position.x >= 1168 and direction == 1:
		velocity.x = 0
	if position.x <= 320 and direction == -1:
		velocity.x = 0
func chase():
	velocity = player_position.normalized() * 800

func _on_timer_para_onda_timeout():
	print("opa")
	var waves = ondas.instantiate()
	get_parent().add_child(waves)
	waves.position = self.global_position
	waves.velocit = $RayCast2D.target_position
	
func _on_timer_para_chase_timeout() -> void:
	pass
