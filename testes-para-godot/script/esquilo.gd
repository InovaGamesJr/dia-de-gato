extends CharacterBody2D

@onready var shoot : Timer = $shoot
@onready var player_cast: RayCast2D = $mira_player
@onready var esquilo: CharacterBody2D = $"."
var bulletpath = preload("res://scenes/nuts.tscn")

var speed = 300
var gravity = 10
enum states {moving, idle, falling, time_waiting, waiting, fling, shooting, tween, auto}
var state = states.idle
var direction = -1
var player 
var player_position



func _ready() -> void:
	pass
	
func _process(delta: float):
	
	player = get_parent().get_node("boneco")
	player_position = player.position
	
	player_cast.target_position = $"../boneco/Camera_Principal_Xand".global_position - global_position
	

func _physics_process(delta):
	match state:
		states.idle:
			idle()
		states.moving:
			moving()
		states.falling:
			falling(delta)
		states.fling:
			fling()
		states.waiting:
			pass
		states.shooting:
			shooting()
		states.tween:
			tween(delta)
	move_and_slide()
	


func idle():
	
	if not is_on_floor():
		state = states.falling
		
	if is_on_floor():
		velocity.x = direction * speed
	
	if $Colide_Left.is_colliding():
		state = states.moving
		

func moving():
	
	if $Colide_Left.is_colliding():
		velocity.x = -direction * speed
	if $Colide_Right.is_colliding():
		velocity.x = direction * speed
		
	if direction < 0:
		if esquilo.position.x >= 896:
			velocity.x = 0
			state = states.fling
	
	
func falling(_delta):
	velocity.y += gravity 
	if is_on_floor():
		velocity.y = 0 
		state = states.idle
		

func fling():
	velocity.x = 0
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.CRIMSON, 2)
	await tween.finished
	velocity.y = -speed
	
	if esquilo.position.y <= 470:
		velocity.y = 0


func shooting():
	velocity.x = 0

func tween(delta):
	velocity.x = speed
	state = states.shooting

func _on_shooting_timeout():

	var nozes = bulletpath.instantiate()
	get_parent().add_child(nozes)
	nozes.position = player_cast.global_position
	nozes.velocit = player_cast.target_position
