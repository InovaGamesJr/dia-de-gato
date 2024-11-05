extends AnimatedSprite2D

var speed : int = 300

func _physics_process(delta: float):
	move_local_y(speed * delta)

func _on_vanish_timer_timeout():
	queue_free()

func _on_hit_box_area_entered(area: Area2D):
	print("Nut entrou na area")
	nut_impact()

func nut_impact():
	queue_free()
