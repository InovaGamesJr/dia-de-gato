extends State
class_name IdleState


@export var air_state : State
@export var dash_state : State
@export var climb_state : State
@export var knockback_state : State
@export var attack_state : State


func state_input(event : InputEvent):
	
	if(event.is_action_pressed("jump") and character.is_on_floor()):
		next_state = air_state
		
	if(event.is_action_pressed("dash") and timer_dash.is_stopped()):
		next_state = dash_state
	
	if(event.is_action_pressed("attack")):
		next_state = attack_state
	

func state_process(delta):
	pass

func on_enter():
	playback.travel("idle")
