extends CharacterBody2D

@onready var nuts_point: Marker2D = $Nuts_Point
@onready var squirrel_animated: AnimatedSprite2D = $Squirrel_Animated
@export  var enemy_squirrel: CharacterBody2D
@export  var time_to_target : float = 2

var nut = preload("res://Nuts/nuts.tscn")

enum squirrel_state {
	Idle,
	Shoot,
	Chase,
	Death,
	Climb_tree,}

var player : CharacterBody2D
var gravity : int = 1000
var direction  : int
var speed : int = 200
var slow_down_speed : int = 300
var current_state : squirrel_state
var has_target : bool
var player_position : Vector2

func _ready():
	current_state = squirrel_state.Shoot
	player = Global.playerBody

func _physics_process(delta : float):
	enemy_gravity(delta)
	
	move_and_slide()
	
	handle_state_and_animations(delta)
	#print("Current_State: ",  squirrel_state.keys()[current_state])

func enemy_gravity(delta : float):
	velocity.y += gravity * delta

# FUNCAO POSICAO BASE DO ESQUILO E FREIO PARA QUANDO TERMINAR DE PERSEGUIR
func squirrel_idle(delta : float):
	velocity.x = move_toward(velocity.x, 0, slow_down_speed * delta)
	if velocity.x == 0:
		current_state = squirrel_state.Shoot

# FUNCAO DE PERSEGUICAO DO ESQUILO
func squirrel_chase(delta : float):
	enemy_squirrel.velocity.x += direction * 1.5 * speed * delta
	enemy_squirrel.velocity.x = clamp(enemy_squirrel.velocity.x, -speed, speed)

# FUNCOES REFERENTES A ENTRADA E SAIDA DA AREA DE ATAQUE DO ESQUILO
func _on_attack_area_body_entered(body : CharacterBody2D):
	if body.is_in_group("Player"):
		current_state = squirrel_state.Chase
func _on_attack_area_body_exited(body : CharacterBody2D):
	if body.is_in_group("Player"):
		current_state = squirrel_state.Idle

# FUNCOES REFERENTES A ENTRADA E SAIDA DA ZONA DE TIRO DO ESQUILO
func _on_shoot_area_body_entered(body : CharacterBody2D):
	if body.is_in_group("Player"):
		print("ENTROU na Zona de Tiro")
		player_position = player.global_position
		has_target = true
func _on_shoot_area_body_exited(body : CharacterBody2D):
	if body.is_in_group("Player"):
		print("SAIU da Zona de Tiro")
		has_target = false

func _on_squirrel_shoot_timeout():
	if current_state != squirrel_state.Chase && current_state != squirrel_state.Idle:
		var nut_instance = nut.instantiate() as Node2D
		nut_instance.global_position = nuts_point.global_position
		if has_target:
			var direction_to_target = player_position - nut_instance.global_position
			nut_instance.velocity = Vector2(direction_to_target.x / time_to_target, (direction_to_target.y / time_to_target) - (0.5 * nut_instance.gravity * time_to_target))
			player_position = player.global_position
		elif !has_target:
			nut_instance.velocity = Vector2(direction * 100, -250)
		get_parent().add_child(nut_instance)
		current_state = squirrel_state.Shoot

# FUNCAO QUE GERENCIA OS ESTADOS E ANIMACOES DO ESQUILO
func handle_state_and_animations(delta : float):
	if enemy_squirrel.global_position > player.global_position:
		squirrel_animated.flip_h = false
		direction = -1
	elif enemy_squirrel.global_position < player.global_position:
		squirrel_animated.flip_h = true
		direction = 1
	match current_state:
		squirrel_state.Idle:
			squirrel_animated.play("Idle")
			squirrel_idle(delta)
		squirrel_state.Shoot:
			squirrel_animated.play("Shoot_Nuts")
		squirrel_state.Chase: 
			squirrel_animated.play("Chase")
			squirrel_chase(delta)
		squirrel_state.Death:
			squirrel_animated.play("Death")
		squirrel_state.Climb_tree:
			squirrel_animated.play("Climb_tree")
