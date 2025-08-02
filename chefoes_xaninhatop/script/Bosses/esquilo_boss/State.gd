extends Node
class_name StateEsquilo

var character : CharacterBody2D
var animation_tree : AnimationTree
var next_state : StateEsquilo
var sprite_character : AnimatedSprite2D
var playback : AnimationNodeStateMachinePlayback
var collision : CollisionShape2D

@export var can_move : bool = true


func state_input(event):
	pass
	
func state_process(delta):
	pass

func on_enter():
	pass

func on_exit():
	pass
