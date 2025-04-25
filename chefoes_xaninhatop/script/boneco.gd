extends CharacterBody2D

@onready var animation = $"animações_gato"

var speed_movement : int = 140
var jumping_force : int = -340
var gravity_force : int = 800
enum states {idle, running, jumping, dash, climbing, knockback}
var state = states.idle
var dash_velocity = Vector2(80, 0)
var climb_speed : int = -50
var on_leader : bool = false
var knockback_velocity = Vector2(40, 0)
var double_jump : bool = false
var dash_timer : bool = true


func _process(_delta: float) -> void:
	pass


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
		states.climbing:
			climbing()
		states.knockback:
			knockback(delta)
		
	move_and_slide()

func idle(delta):
	velocity.x = 0
	if is_on_floor():
		animation.play("idle")
	if Input.get_axis("left", "right"):
		state = states.running
	if Input.is_action_just_pressed("jump"):
		state = states.jumping
	if Input.is_action_just_pressed("dash") and dash_timer == true:
		state = states.dash
		
	if on_leader == true:
		leader()
	
	if on_leader == false:
		gravity(delta)
	
func running(delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed_movement
		if is_on_floor():
			animation.play("running")
	else:
		velocity.x = 0
		state = states.idle
	if Input.is_action_just_pressed("jump"):
		state = states.jumping
	if Input.is_action_just_pressed("dash") and dash_timer == true:
		state = states.dash
	
	
	if direction == -1:
		$sprites_gato.flip_h = true
		dash_velocity = Vector2(-85, 0)
		knockback_velocity = Vector2(40, 0)
	elif direction == 1:
		$sprites_gato.flip_h = false
		knockback_velocity = Vector2(-40, 0)
		dash_velocity = Vector2(85, 0)
	gravity(delta)
	
	if on_leader == true:
		leader()


func jumping(delta):
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jumping_force
		animation.play("jumping")
	if Input.is_action_pressed("jump") and double_jump == false and !is_on_floor():
		double_jump = true
		velocity.y = jumping_force
		animation.play("jumping")
	if is_on_floor():
		double_jump = false
		state = states.idle
	if Input.get_axis("left", "right"):
		state = states.running
	gravity(delta)
	
func dash(delta):
	if Input.is_action_pressed("dash"):
		velocity = dash_velocity.normalized() * 300
		animation.play("dash")
		await animation.animation_finished
		$dash_timer.start()
		dash_timer = false
		state = states.idle
		
func climbing():
	velocity.x = 0
	if Input.is_action_pressed("climb"):
		velocity.y = climb_speed
	else:
		velocity.y = 0

func gravity(delta):
	velocity.y += gravity_force * delta
	
func leader():
	if Input.is_action_pressed("climb"):
		velocity.y = climb_speed
	else:
		velocity.y = 0

func knockback(delta):
	velocity = knockback_velocity.normalized() * 150
	animation.play("knockback")
	await animation.animation_finished
	state = states.idle
	
	gravity(delta)
	
func _on_area_puxao_body_entered(body: Node2D) -> void:
	if body.name == "boneco":
		await get_tree().create_timer(0.2).timeout
		var esquilo = get_parent().get_node("Boss_Esquilo")
		var tween = create_tween()
		tween.tween_property(self, "position", esquilo.position + Vector2(0, -16), 0.67)


func _on_area_de_colisão_area_entered(area: Area2D) -> void:
	if area.name == "escada":
		on_leader = true
	if area.name == "enemy":
		state = states.knockback
	if area.name == "boss_area":
		state = states.knockback
	if area.name == "kill_zone":
		pass
	if area.name == "check_point":
		pass


func _on_dash_timer_timeout() -> void:
	dash_timer = true
