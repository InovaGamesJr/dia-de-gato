extends CharacterBody2D

var velocit = Vector2(0, 0)
var speed = 50

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocit.normalized() * delta * speed)

func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
