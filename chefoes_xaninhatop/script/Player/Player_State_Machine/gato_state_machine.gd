extends Node

class_name GatoStateMachine

@export var character : CharacterBody2D
@export var animation_tree : AnimationTree
@export var sprite_character : AnimatedSprite2D
@export var timer_dash : Timer

@export var current_state : State

var states : Array[State]

func _ready() -> void:
	for child in get_children():
		if(child is State):
			states.append(child)
			
			child.character = character
			child.playback = animation_tree["parameters/playback"]
			child.sprite_character = sprite_character
			child.timer_dash = timer_dash
			
func _physics_process(delta: float) -> void:
	if(current_state.next_state != null):
		switch_states(current_state.next_state)
		
	current_state.state_process(delta)
	current_state.character.move_and_slide()
	
func switch_states(new_state : State):
	
	if(current_state != null):
		current_state.on_exit()
		current_state.next_state = null
	
	
	current_state = new_state
	current_state.on_enter()

func _input(event: InputEvent) -> void:
	current_state.state_input(event)
