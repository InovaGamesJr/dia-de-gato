extends CharacterBody2D

@onready var nuts_point: Marker2D = $Nuts_Point
@onready var squirrel_animated: AnimatedSprite2D = $Squirrel_Animated

var nut = preload("res://Nuts/nuts.tscn")

var gravity : int = 1000

func _physics_process(delta: float):
	enemy_gravity(delta)
	
	move_and_slide()

func enemy_gravity(delta : float):
	velocity.y += gravity * delta

func _on_shooting_timeout():
	var nut_instance = nut.instantiate() as Node2D
	nut_instance.global_position = nuts_point.global_position
	get_parent().add_child(nut_instance)
	squirrel_animated.play("Shoot")
