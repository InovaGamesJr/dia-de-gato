extends CharacterBody2D

var gravity : int = 300

func _physics_process(delta: float):
	nuts_gravity(delta)
	
	move_and_slide()

func nuts_gravity(delta : float):
	velocity.y += gravity * delta 

func _on_vanish_timer_timeout():
	queue_free()

func _on_hit_box_area_entered(area: Area2D):
	print("Nut atinjiu o player")
	nut_impact()

func nut_impact():
	queue_free()
