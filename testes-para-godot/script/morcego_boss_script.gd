extends CharacterBody2D


@onready var player = get_parent().get_node("player").get_node("boneco")
enum states {idle, fling, chasing, right, left, chase, waiting}
var state = states.idle
var ondas = preload("res://scenes/ondas.tscn")
var speed = 40
var enemy_go

func _ready() -> void:
	match state:
		states.right:
			$"timer para chase".start()

func _process(float):
	var player_position = player.position
	$RayCast2D.target_position = player_position - global_position

func _physics_process(delta):
	match state:
		
		states.idle:
			idle()
			
		states.chasing:
			chasing(delta)
			
		states.fling:
			fling()
			
		states.chase:
			chase(delta)
		
		states.waiting:
			pass
	
func idle():
	velocity.y = speed
	if self.position.y >= 494:
		velocity.y = 0
		state = states.fling
	move_and_slide()
	
func fling():
	velocity.y = -speed * 2
	if self.position.y <= 330:
		velocity.y = 0
		state = states.chasing
	move_and_slide()
	
func chasing(delta):
	var random_int = 1
	if random_int == 0:
		state = states.left
	elif random_int == 1:
		state = states.right
	move_and_slide()
	
func right():
	velocity.x = speed * 2
	if self.position.x >= 1050:
		velocity.x = 0
	move_and_slide()
	

func chase(delta):
	velocity.x = 0
	var player = get_parent().get_node("boneco")
	var target = (player.position - position).normalized()
	move_and_collide(target * delta * speed * 6)
	print(self.global_position)


func _on_timer_para_onda_timeout():
	var ondas1 = ondas.instantiate()
	get_parent().add_child(ondas1)
	ondas1.position = $"../segundo marcado".global_position
	ondas1.rotation = 1.0
	ondas1.velocit = Vector2(188, 222)
	var tween = create_tween()
	tween.tween_property(ondas1, "scale", Vector2(3, 3), 4.5)
	
	

func _on_timer_para_chase_timeout() -> void:
	print("presta")
