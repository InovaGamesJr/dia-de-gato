extends CharacterBody2D

@onready var bat_direction_timer: Timer = $Direction_Timer
@onready var chase_timer: Timer = $Chase_Timer
@onready var bat_vision: Area2D = $VisionArea
@onready var bat_animations: AnimatedSprite2D = $"Bat Animations"

var player : CharacterBody2D
enum bat_state { 
	FLY, 
	SLEEP,
	SCREAM,
	DEATH, }
var current_state : bat_state
var speed : int = 50
var dive : int = 0
var direction  : Vector2
var is_bat_chase : bool
var is_sleep : bool
var can_fly : bool

func _ready():
	is_sleep = true # ELE PERMANECE DORMINDO ATE QUE OU ELE ENTRE NA AREA DE VISAO DO MORCEGO OU PASSE POR UMA COLISAO ESPECIFICA
	is_bat_chase = false # ELE OBVIAMENTE NAO VAI COMECAR A PERSEGUIR O INIMIGO
	can_fly = false
	chase_timer.wait_time = 2
	current_state = bat_state.SLEEP

func _process(delta : float):
	bat_sleep(delta)
	bat_move(delta)
	bat_chase(delta)
	bat_tired(delta)
	
	handle_animation_states(delta)
	move_and_slide()

func bat_sleep(delta : float):
	if is_sleep:
		velocity.x = move_toward(velocity.x, 0, speed * delta)

# FUNCAO QUE ACORDA O MORCEGO
func bat_awaken():
	if is_sleep:
		is_sleep = false
		can_fly = true
		bat_direction_timer.start()
	else:
		return

# FUNCAO PARA A VELOCIDADE DO MORCEGO
func bat_move(delta : float):
	if can_fly:
		if !is_bat_chase:
			velocity += direction * speed * delta # AQUI ELE APENAS ASSUME A VELOCIDADE NORMAL DO MORCEGO QUANDO NAO ESTA PERSEGUINDO 
		current_state = bat_state.FLY

# FUNCAO PARA A PERSEGUICAO DO MORCEGO NO PLAYER
func bat_chase(delta : float):
	if can_fly:
		if is_bat_chase: 
			player = Global.playerBody # A VAR PLAYER ASSUME O CONTEUDO DA VAR GLOBAL PLAYERBODY 
			velocity = position.direction_to(player.position) * 2.5 * speed # EQUACAO QUE IRA FAZER O MORCEGO IR EM DIRECAO AO PLAYER 
			direction.x = abs(velocity.x) / velocity.x # EQUACAO PARA DECIDIR A DIRECAO DO MORCEGO, SE VELOCITY.X = 1 |1|/1 = 1 VAI PARA A DIREITA, SE VELOCITY.X = -1 |-1|/-1 = -1 VAI PARA A ESQUERDA
			dive += 1 # DIVE = MERGULHO, DURANTE O TEMPO QUE ELE ESTIVER PERSEGUINDO ELE ADICIONARA ATE ATINGIR UM VALOR ESPECIFICO
		current_state = bat_state.FLY
	#debugging
	#print(dive)

# FUNCAO PARA O MORCEGO PARAR DE PERSEGUIR POR ~10 SEGUNDOS E VOLTAR A PERSEGUIR A CADA 2 SEGUNDOS
func bat_tired(delta : float):
	if dive > 300: # VALOR GENERICO QUE DIVE DEVE ATINGIR PARA PARAR DE PERSEGUIR
		chase_timer.wait_time = 10
		if dive > 400: # VALOR ACIMA PARA VOLTAR A PERSEGUIR
			chase_timer.wait_time = 2
			dive = 0 
	#debugging
	#print(chase_timer.wait_time)

# FUNCAO PARA AS STATES DE ANIMACAO
func handle_animation_states(delta : float):
	match current_state:
		bat_state.FLY:
			bat_animations.play("Fly") 
			if direction.x == -1: # ESQUERDA
				bat_animations.flip_h = true
				bat_vision.scale.x = -abs(bat_vision.scale.x) # ESPELHA A COLISSAO PARA A ESQUERDA
			if direction.x == 1:  # DIRETA
				bat_animations.flip_h = false
				bat_vision.scale.x = abs(bat_vision.scale.x) # ESPELHA A COLISSAO PARA A DIREITA
		bat_state.SLEEP: 
			bat_animations.play("Sleep")
		bat_state.SCREAM:
			pass
		bat_state.DEATH:
			pass

						   # TIMERS:

# FUNCAO DO TIMER DA PERSEGUICAO
func _on_chase_timer_timeout():
	is_bat_chase = !is_bat_chase # A CADA 5 SEGUNDOS ELE FLIPA ENTRE TRUE OU FALSE

# FUNCAO DO TIMER PARA QUANDO O MORCEGO NAO ESTIVER EM PERSEGUICAO
func _on_direction_timer_timeout():
	bat_direction_timer.wait_time = choose([0.5, 0.8]) # ALTERNA ENTRE 0.5 OU 0.8 SEGUNDOS
	if !is_bat_chase:
		direction = choose([Vector2.UP,Vector2.LEFT, Vector2.DOWN, Vector2.RIGHT]) # DECIDE ALEATORIAMENTE A DIRECAO DO MORCEGO

# FUNCAO PARA AS ESCOLHAS DE VETORES
func choose(array):
	array.shuffle()
	return array.front()

# FUNCAO DA VISAO DO MORCEGO PARA PERCEBER O PLAYER
func _on_vision_area_body_entered(body : CharacterBody2D):
	if body.is_in_group("Player"): # SE PERTENCE AO GRUPO PLAYER E NA ESTA PERSEGUINDO
		dive = 0
		is_bat_chase = true
		chase_timer.start() # TIMER PARA ALTENAR O MODO DE PERSEGUICAO A CADA 5 SEGUNDOS
		chase_timer.wait_time = 2 
