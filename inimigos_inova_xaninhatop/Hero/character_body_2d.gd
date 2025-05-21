extends CharacterBody2D

#Exports para mexer diretamentes nos nós
@onready var spriteGato: AnimatedSprite2D = $AnimatedSprite2D

#Estados do player
enum states {
	idle, 
	running, 
	jumping, 
	dash, 
	climbing, 
	knockback
	}
var current_state : states

#Variaveis da fisica
var speed : int = 140
var jumpingForce : int = -250
var forceGravity : int = 800
var knockbackDir = Vector2()

#Booleanos
var doubleJump : bool = false
var dashBool : bool = true

func _ready():
	Global.playerBody = self
	current_state = states.idle

func _physics_process(delta):
	gravity(delta)
	player_actions()
	match current_state:
		states.idle:
			idle()
		states.running:
			running(delta)
		states.jumping:
			pass
		states.dash:
			pass
		states.climbing:
			pass
		states.knockback:
			pass
	#print("Estado: ", states.keys()[current_state])

	move_and_slide()

func gravity(delta : float):
	if !is_on_floor():
		velocity.y = forceGravity * delta 

func player_actions():
	if Input.get_axis("Left", "Right"):
		current_state = states.running

func idle():
	if is_on_floor():
		spriteGato.play("Idle")

func running(delta : float):
	var direction = Input.get_axis("Left", "Right") # 1 ou -1
	if direction:
		velocity.x = lerp(velocity.x, direction * speed, 1)
		if is_on_floor():
			spriteGato.play("Running")
	else:
		velocity.x = 0
		current_state = states.idle
	
	if direction != 0:
		spriteGato.flip_h = false if direction > 0 else true #Operador Tenario, usar if em uma linha, se a direcao for 1 (direita) o flip_h vai ser FALSE(mantendo a orientacao original), caso contrario -1(Esquerda) o flip_h se torna TRUE mudando a direcao do personagem pra a esquerda.
