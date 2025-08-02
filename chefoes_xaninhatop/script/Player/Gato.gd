extends CharacterBody2D

@export var health_component : HealthComponent
@export var state_machine : GatoStateMachine
@export var animation_tree : AnimationTree
@export var animated_sprite : AnimatedSprite2D
@export var ground_state : State

var gravity_force : int = 800
var speed : float = 200
var playback

var nuts = preload("res://scenes/nuts_bullet.tscn")
var Nuts : Bullet

func _input(event: InputEvent) -> void:
	pass

func _ready() -> void:
	playback = animation_tree["parameters/playback"]
	
func _process(delta: float) -> void:
	if(not is_on_floor() and state_machine.current_state.apply_gravity):
		gravity(delta)

func _physics_process(delta: float) -> void:
	
	var direction = Input.get_axis("left", "right")
	
	if direction and state_machine.current_state.can_move:
		velocity.x = direction * speed
		if is_on_floor():
			playback.travel("running")
		
	else:
		if(state_machine.current_state == ground_state):
			velocity.x = 0
			playback.travel("idle")
			
	if direction == -1:
		animated_sprite.flip_h = true
	if direction == 1:
		animated_sprite.flip_h = false

func gravity(delta):
	velocity.y += gravity_force * delta
