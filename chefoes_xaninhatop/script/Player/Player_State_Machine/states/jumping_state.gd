extends State
class_name AirState

var jump_velocity : int = -200
var run_velocity : int = 200
var is_jumping : bool = false

@export var idle_state : State
@export var dash_state : State

func state_input(event : InputEvent):
	if event.is_action_pressed("dash") and timer_dash.is_stopped():
		next_state = dash_state

func state_process(delta):
	if character.is_on_floor() and is_jumping:
		next_state = idle_state
		is_jumping = false
		
func on_enter():
	if character.is_on_floor():
		playback.travel("jumping")
		character.velocity.y = jump_velocity
	else:
		playback.travel("falling")
		
func verify_state():
	is_jumping = true
