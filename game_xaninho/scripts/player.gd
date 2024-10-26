extends CharacterBody2D

@onready var anime: AnimatedSprite2D = $AnimatedSprite2D
@onready var restart_dash: Timer = $RestartDash
@onready var anime_dash: AnimatedSprite2D = $AnimatedSprite2D

var input
var speed = 100.0
var gravity = 8
const JUMP_VELOCITY = -400.0
var jump_count = 0  # Contador de pulos
@export var max_jump = 2  # Número máximo de pulos permitidos
@export var jump_force = 275  # Força aplicada ao pular	
var dash_force = 600 * 20
var wait_time : float = 1.5
var can_dash: bool  # Dash ativado por padrão
enum player_states {MOVE, SWORD, DASH}
var current_state = player_states.MOVE

func _ready():
	can_dash = true
	restart_dash.wait_time = wait_time
	

func _physics_process(delta: float) -> void:
	match current_state:
		player_states.MOVE:
			movement(delta)
		player_states.SWORD:
			sword(delta)
		player_states.DASH:
			dashing(delta)

func movement(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if input > 0:
		velocity.x = speed  # Define a velocidade para a direita
		anime.play("run")  # Reproduz a animação de andar
		anime.flip_h = false  # Garante que o personagem esteja virado para a direita
	# Movimento para a esquerda
	elif input < 0:
		velocity.x = -speed  # Define a velocidade para a esquerda
		anime.play("run")  # Reproduz a animação de andar
		anime.flip_h = true  # Espelha o personagem para a esquerda
	# Sem movimento
	else:
		velocity.x = 0  # Zera a velocidade horizontal
		anime.play("idle")  # Reproduz a animação de idle (parado)
	if can_dash:
		if Input.is_action_just_pressed("ui_dash"):
			current_state = player_states.DASH
	# Chama a função de movimentação normal
	attacknmove(delta)
	
	if is_on_floor():  # Reseta o contador de pulo quando está no chão
		jump_count = 0
	
	# Define as animações de pulo e queda

	if velocity.y < 0:
		anime.play("jump")  # Animação de pulo

	# Verifica se o jogador pressionou a tecla de pulo e está no chão
	if Input.is_action_pressed("Jump") and is_on_floor() and jump_count < max_jump:
		jump_count += 1  # Incrementa o contador de pulo
		velocity.y = -jump_force  # Aplica a força do pulo
	
	# Permite um segundo pulo enquanto o personagem está no ar
	if !is_on_floor() and Input.is_action_just_pressed("Jump") and jump_count < max_jump:
		jump_count += 1
		velocity.y = -jump_force  # Aplica a força do segundo pulo
	
	# Se o jogador soltar o botão de pulo, aplica uma gravidade maior
	if !is_on_floor() and Input.is_action_just_released("Jump") and jump_count < max_jump:
		velocity.y = gravity * 1.5
		velocity.x -= input  # Reduz a velocidade no ar
	else:
		gravity_force()  # Aplica a gravidade normalmente
	
	# Move o personagem e resolve colisões
	move_and_slide()

func gravity_force():
	# Função que aplica a força da gravidade no personagem
	velocity.y += gravity

func attacknmove(delta):
	if input != 0:
		if input > 0:
			velocity.x = speed
		elif input < 0:
			velocity.x = -speed
	else:
		velocity.x = 0

	velocity.y += gravity  # Aplica gravidade
	move_and_slide()

func sword(delta):
	pass

func dashing(delta):
	if velocity.x > 0:
		velocity.x += dash_force 
		await get_tree().create_timer(0.1).timeout
	elif velocity.x < 0:
		velocity.x -= dash_force
		await get_tree().create_timer(0.1).timeout
	else: 
		if anime_dash.scale.x == 1:
			velocity.x += dash_force # Avanca pra frente
			await get_tree().create_timer(0.1).timeout 
		if anime_dash.scale.x == -1:
			velocity.x -= dash_force # Avanca pra frente
			await get_tree().create_timer(0.1).timeout 
	can_dash = false
	restart_dash.start()
	move_and_slide()
	restart_states()

func restart_states():
	current_state = player_states.MOVE
func _on_restart_dash_timeout():
	can_dash = true  # Restaura a possibilidade de dash após o tempo de espera
