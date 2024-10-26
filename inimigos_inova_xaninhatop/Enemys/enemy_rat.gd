extends CharacterBody2D

const SPEED = 250
const gravity = 1000
var direction = -1
@onready var ray_cast_right  = $RayCastRight
@onready var ray_cast_left   = $RayCastLeft
@onready var rat_animations  = $"Rat Animations"

func _physics_process(delta : float):
	enemy_gravity(delta)
	
	move_and_slide()
# TODO FUNCIONAMENTO DO INIMIGO ESTA AQUI DENTRO SE O RAYCAST INTERAGIR COM A PAREDE ELE MUDA DE DIRECAO
func _process(delta : float):
	if ray_cast_right.is_colliding():
		direction = -1
		rat_animations.flip_h = true
	elif ray_cast_left.is_colliding():
		direction = 1
		rat_animations.flip_h = false
	position.x += direction * SPEED * delta

# FUNCAO DA GRAVIDADE
func enemy_gravity(delta : float):
	velocity.y += gravity * delta
