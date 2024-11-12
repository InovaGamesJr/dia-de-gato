extends CharacterBody2D

@onready var centrodoplayer = get_parent().get_node("player/centro_gato")
@onready var player = get_parent().get_node("player").get_node("boneco")
enum states {idle, fling, chasing, right, left, chase, waiting}
var state = states.idle
var ondas = preload("res://scenes/ondas.tscn")
var speed : int = -120
var enemy_go

func _ready() -> void:
	pass

func _process(float):
	$RayCast2D.target_position = centrodoplayer.global_position - self.global_position

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
		
		states.right:
			right()
	
	move_and_slide()
	
func idle():
	velocity.y = speed
	await get_tree().create_timer(2.0).timeout
	velocity.y = 0
	state = states.right

	
func chasing(delta):
	var random_int = 1
	if random_int == 0:
		state = states.left
	elif random_int == 1:
		state = states.right

	
func right():
	velocity.x = speed * -2
	if self.position.x >= 1120:
		velocity.x = 0
		$"timer para onda".start()
		state = states.fling

func fling():
	await get_tree().create_timer(7.0).timeout
	$"timer para onda".stop()
	state = states.chase
	
func chase(delta):
	pass


func _on_timer_para_onda_timeout():
	print("opa")
	var waves = ondas.instantiate()
	get_parent().add_child(waves)
	waves.position = self.global_position
	waves.velocit = $RayCast2D.target_position
	
func _on_timer_para_chase_timeout() -> void:
	pass
