extends Node
class_name State

var character : CharacterBody2D
var next_state : State
var sprite_character : AnimatedSprite2D
var playback : AnimationNodeStateMachinePlayback
var timer_dash : Timer


@export var can_move : bool = true
@export var apply_gravity : bool = true

func state_input(event):
	pass
	
func state_process(delta):
	pass

func on_enter():
	pass

func on_exit():
	pass
