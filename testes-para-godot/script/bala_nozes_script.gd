extends CharacterBody2D

var speed = 130
var velocit = Vector2(0, 0)

func _physics_process(delta):
	var _collision = move_and_collide(velocit.normalized() * delta * speed)
