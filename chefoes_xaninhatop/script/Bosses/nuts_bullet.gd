extends CharacterBody2D
class_name Bullet

var bullet_speed : int = 80
var vector_down : Vector2 = Vector2.DOWN

@export var animation_player_bullet : AnimationPlayer

enum state {nul, attack1, attack2, attack3}
var states = state.attack2

func _ready() -> void:
	animation_player_bullet.play("bullet")

func _physics_process(delta: float) -> void:
	match states:
		state.attack1:
			attack1(delta)
		state.attack2:
			attack2(delta)
	
	
func attack1(delta):
	var collision = move_and_collide(vector_down * bullet_speed)
	if collision:
		var collider = collision.get_collider()
		if collider:
			animation_player_bullet.play("kaboom")
			
func attack2(delta):
	var direction = (get_global_mouse_position() - global_position).normalized()
	global_position += direction * delta * 100
	look_at(get_global_mouse_position())
