extends State

var dash_velocity : int = 400
var stopped : bool = false

@export var ground_state : State
@export var air_state : State

func on_enter():
	timer_dash.start()
	playback.travel("dash")
	if sprite_character.flip_h == true:
		character.velocity.x = -dash_velocity
	if sprite_character.flip_h == false:
		character.velocity.x = dash_velocity

	character.velocity.y = 0
	
func on_exit():
	character.velocity.x = 0

func change_state_in_animation_player():
	if character.is_on_floor():
		next_state = ground_state
	else:
		next_state = air_state
