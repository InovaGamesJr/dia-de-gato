extends CharacterBody2D


var nuts = preload("res://scenes/nuts_bullet.tscn")
@export var state_machine : EsquiloStateMachine


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		pass


func _physics_process(delta: float) -> void:
	move_and_slide()
	
func gravity():
	velocity.y += 1.8

func start_shooting():
	pass
	
func _on_timer_timeout() -> void:
	var Nuts = nuts.instantiate()
	Nuts.global_position = Vector2(-25, 7)
	Nuts.rotation = 1.5708
	Nuts.vector_down = Vector2.LEFT
	
	add_child(Nuts)
	
