extends StateEsquilo

@export var jump_state : StateEsquilo
@export var attack_on_air : StateEsquilo

func state_input(event : InputEvent):
	if event.is_action_pressed("attack"):
		next_state = attack_on_air
	
func on_enter():
	playback.travel("idle")
	character.velocity.x = 0
