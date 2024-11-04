extends CharacterBody2D

@onready var animation = $"animações_gato"

var speed_movement : int = 140
var jumping_force : int = -200
var gravity_force : int = 800
enum states {idle, running, jumping, dash}
var state = states.idle
var dash_velocity = Vector2(80, 0)

func _process(_delta: float) -> void:
	print(state)


func _physics_process(delta):
	match state:
		states.idle:
			idle(delta)
		states.running:
			running(delta)
		states.jumping:
			jumping(delta)
		states.dash:
			dash(delta)
		
	move_and_slide()

func idle(delta):
	if not is_on_floor():
		gravity(delta)
	if is_on_floor():
		velocity.x = 0
	elif is_on_floor():
		animation.play("idle")
	if Input.get_axis("left", "right"):
		state = states.running
	if Input.is_action_just_pressed("jump"):
		state = states.jumping
	if Input.is_action_just_pressed("dash"):
		state = states.dash
	
func running(delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed_movement
		animation.play("running")
	else:
		velocity.x = 0
		state = states.idle
	if Input.is_action_just_pressed("jump"):
		state = states.jumping
	
	if direction == -1:
		$sprites_gato.flip_h = true
	elif direction == 1:
		$sprites_gato.flip_h = false
	gravity(delta)

func jumping(delta):
	if Input.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y = jumping_force
	if not is_on_floor():
		gravity(delta)
	if is_on_floor():
		state = states.idle
	if Input.get_axis("left", "right"):
		state = states.running

func dash(delta):
	if Input.is_action_pressed("dash"):
		velocity = dash_velocity.normalized() * 300
		await get_tree().create_timer(0.1).timeout
		state = states.idle


func _on_area_puxao_body_entered(body: Node2D) -> void:
	if body.name == "boneco":
		await get_tree().create_timer(0.2).timeout
		var esquilo = get_parent().get_node("Boss_Esquilo")
		var tween = create_tween()
		tween.tween_property(self, "position", esquilo.position + Vector2(0, -16), 0.67)

func gravity(delta):
	velocity.y += gravity_force * delta
