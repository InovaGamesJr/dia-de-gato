extends CharacterBody2D

@onready var centrodoplayer = get_parent().get_node("gato/centro_gato")
@onready var player_cast : RayCast2D = $mira_player
@onready var esquilo : CharacterBody2D = $"."
@onready var boneco = $"../gato"

var positionx : float 
var positiony : float 
var areaposition = Vector2(0, 0)

#Váriaveis para o inicio do jogo!!!
var pulo_inicio : int = 300
var queda_inicio : int = 10

var finish_turre : bool = false
var timer_tiros : bool = false

#Variaveis para velocidade do player, instanciar o tiro, e para a velocidade dos tiros e também a gravidade
var speed_player : int = 60 
var speed_shoot : int = 40
var gravity : int = 20
var bulletpath = preload("res://scenes/nuts.tscn")

#Aqui são os estados do esquilo, sendo a principal waiting, que só deixa ele parado mesmo
enum states {moving, idle, falling, waiting, fling, shooting, start_shooting, hit, pulo, grab, queda}
var state = states.waiting
 
var direction = -1
var destino_soco = Vector2.ZERO
	

func _ready() -> void:
	pass
			
func _process(float):
	#Sempre o raycast mirando no player, mas talvez não seja necessario no final, mas, ajuda!
	$mira_player.target_position = centrodoplayer.global_position - global_position
	
	#Posições para o raycast de grab!
	
	positionx = centrodoplayer.get_parent().position.x - self.position.x
	positiony = centrodoplayer.get_parent().position.y - (self.position.y - 13)


func _physics_process(delta):
	
	match state:
		states.idle:
			idle()
		states.moving:
			moving()
		states.falling:
			falling()
		states.fling:
			fling()
		states.hit:
			hit()
		states.waiting:
			velocity = Vector2.ZERO
		states.pulo:
			pulo()
		states.queda:
			queda()
	move_and_slide()

func idle():

	if is_on_floor(): #Aqui ele já está no chão, então começará a se mover em direção ao player
		state = states.moving
	
		
func moving():
	if $mira_player.target_position.x > 0:
		var move = Vector2(1, 0)
		velocity = move.normalized() * 100
		
	elif $mira_player.target_position.x < 0:
		var move = Vector2(-1, 0)
		velocity = move.normalized() * 100
		var timer = await get_tree().create_timer(0.7).timeout
		state = states.waiting
		
	
	
func falling():
	velocity.y += gravity 
	if is_on_floor():
		velocity.y = 0
		

func fling():
	velocity.x = 0
	velocity.y = -speed_player
	
	if esquilo.position.y <= 470:
		velocity.y = 0
		state = states.start_shooting
		

func start_shooting():
	if timer_tiros == false:
		$Timer.start()
		timer_tiros = true
	if finish_turre == false:
		var numero_random : int = randi_range(7, 16)
		print(numero_random)
		$finish_turret.wait_time = numero_random
		$finish_turret.start()
		finish_turre = true
	
func shooting():
	#Função para atirar as balas, aqui ele instancia elas, criando novos objetos
	var nozes = bulletpath.instantiate()
	get_parent().add_child(nozes)
	nozes.position = player_cast.global_position
	nozes.velocit = player_cast.target_position

func hit():
	pass

func _on_timer_timeout() -> void:
	shooting()

func _on_finish_turret_timeout() -> void:
	$Timer.stop()
	timer_tiros = false
	finish_turre = false
	$timer_de_dano.start()
	state = states.hit

	
#Funções apenas para iniciar o jogo!!!!
		
func queda():
	velocity.y += queda_inicio
	velocity.x = -queda_inicio * 13
	if is_on_floor():
		velocity.x = 0
		state = states.waiting
		await get_tree().create_timer(2.5).timeout
		state = states.grab

func pulo():
	velocity.y = -pulo_inicio
	if not is_on_floor():
		state = states.queda
		
func interpolate(tamanho, duration):
	var tween_offset = create_tween()
	var tween_rect = create_tween()
	
	tween_offset.tween_property($grab_node/grab_sprite, "offset", Vector2(0, tamanho / 2.0), duration)
	tween_rect.tween_property($grab_node/grab_sprite, "region_rect", Rect2(0, 0, 16, tamanho), duration)

func raycast(targetx, targety, duration):
	
	var tween_target = create_tween()
	tween_target.tween_property($grab, "target_position", Vector2(targetx, targety), duration)

func puxao(areaposition, duration):
	var tween = create_tween()
	tween.tween_property($area_puxao, "position", areaposition, duration)
	
	
func _on_area_detecção_1_body_entered(body: Node2D) -> void:
	if body.name == "gato" and state == states.grab:
		$grab_node/timer_grab.start()

func _on_area_detecção_1_body_exited(body: Node2D) -> void:
	if body.name == "gato" and state == states.grab:
		$grab_node/timer_grab.stop()
	

func _on_timer_grab_timeout() -> void:
	areaposition = centrodoplayer.global_position - global_position
	interpolate(positionx, 1.0)
	raycast(positionx, positiony, 1.0)
	puxao(areaposition, 1.0)
	await get_tree().create_timer(1.2).timeout
	puxao(Vector2(0, -26), 0.7)
	interpolate(0, 0.7)
	raycast(0, 0, 0.7)
