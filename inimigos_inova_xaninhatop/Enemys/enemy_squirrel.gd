extends CharacterBody2D

@onready var squirrel_animated: AnimatedSprite2D = $Squirrel_Animations
@export var enemy_squirrel: CharacterBody2D 
@export var squirrel_animations: AnimatedSprite2D

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

func _ready():
	current_state = squirrel_state.Idle
	player = Global.playerBody

func _physics_process(delta: float):
	enemy_gravity(delta)
	
	move_and_slide()
	
	handle_state_and_animations(delta)
	print("Current_State: ",  squirrel_state.keys()[current_state])

func enemy_gravity(delta : float):
	velocity.y += gravity * delta

# FUNCAO POSICAO BASE DO ESQUILO E FREIO PARA QUANDO TERMINAR DE PERSEGUIR
func squirrel_idle(delta : float):
	velocity.x = move_toward(velocity.x, 0, slow_down_speed * delta)

# FUNCAO DE PERSEGUICAO DO ESQUILO
func squirrel_chase(delta : float):
	enemy_squirrel.velocity.x += direction * 1.5 * speed * delta
	enemy_squirrel.velocity.x = clamp(enemy_squirrel.velocity.x, -speed, speed)

func squirrel_shoot(delta : float):
	pass

# FUNCOES REFERENTES A ENTRADA E SAIDA DA AREA DO ESQUILO
func _on_attack_area_body_entered(body : CharacterBody2D):
	if body.is_in_group("Player"):
		current_state = squirrel_state.Chase
func _on_attack_area_body_exited(body : CharacterBody2D):
	if body.is_in_group("Player"):
		current_state = squirrel_state.Idle

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
			squirrel_shoot(delta)
		squirrel_state.Chase: 
			squirrel_animated.play("Chase")
			squirrel_chase(delta)
		squirrel_state.Death:
			squirrel_animated.play("Death")
		squirrel_state.Climb_tree:
			squirrel_animated.play("Climb_tree")
