extends State
class_name attack

@export var ground_state : State

func on_enter():
	character.velocity.x = 0
	playback.travel("attack")

func change_state():
	next_state = ground_state
	
