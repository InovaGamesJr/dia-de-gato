extends CharacterBody2D

#Exports para mexer diretamentes nos nós
@export var animation : AnimationPlayer
@export var spriteGato : AnimatedSprite2D

#Estados do player
var state = states.idle
enum states {idle, running, jumping, dash, climbing, knockback}

#Variaveis da fisica
var speed : int = 140
var jumpingForce : int = -250
var gravityForce : int = 800
var knockbackDir = Vector2()

#Booleanos
var doubleJump : bool = false
var dashBool : bool = true


#Process é um WHILE(TRUE), entao a gravidade esta sendo constantemente aplicada
func _process(delta: float) -> void:
	gravity(delta)

func _physics_process(delta):
	match state:
		states.idle:
			idle()
		states.running:
			running(delta)
		states.jumping:
			jumping(delta)
		states.dash:
			dash(300)
		states.knockback:
			knockback()
	
	move_and_slide()

func idle():
	velocity.x = 0
	
	if is_on_floor():
		animation.play("idle")
		
	if Input.get_axis("left", "right"):
		state = states.running
		
	if Input.is_action_just_pressed("jump"):
		state = states.jumping
		
	if Input.is_action_just_pressed("dash") and dashBool == true:
		state = states.dash
		
func running(delta):
	var direction = Input.get_axis("left", "right")#Retorna 1 ou -1
	
	if direction:
		velocity.x = lerp(velocity.x, direction * speed, 1)

		if is_on_floor():
			animation.play("running")
			
	else:
		velocity.x = 0
		state = states.idle
		
	if direction == -1:
		spriteGato.flip_h = true
		
		#dash_velocity = Vector2(-85, 0)
		#knockback_velocity = Vector2(40, 0)
		
	elif direction == 1:
		spriteGato.flip_h = false
		
		#knockback_velocity = Vector2(-40, 0)
		#dash_velocity = Vector2(85, 0)
		
	if Input.is_action_just_pressed("jump"):
		state = states.jumping
	#if Input.is_action_just_pressed("dash") and dash_timer == true:
	#	state = states.dash
	
	

func jumping(delta):
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jumpingForce
		animation.play("jumping")
		
	if Input.is_action_pressed("jump") and not doubleJump and !is_on_floor():
		doubleJump = true
		velocity.y = jumpingForce
		animation.play("jumping")
		
	if is_on_floor():
		doubleJump = false
		state = states.idle
		
	if Input.get_axis("left", "right"):
		state = states.running


func dash(velocidadeDash):
	if Input.is_action_pressed("dash"):
		
		if spriteGato.flip_h == false:
			velocity = Vector2(1,0).normalized() * velocidadeDash
		else:
			velocity = Vector2(1,0).normalized() * -velocidadeDash
			
		animation.play("dash")
		await animation.animation_finished
		dashBool= false
		state = states.idle
		await get_tree().create_timer(8.0).timeout
		dashBool = true
		
func gravity(delta):
	velocity.y += gravityForce * delta
	
func knockback():
	knockbackDir.x = 300
	knockbackDir.y = -300
	
	if spriteGato.flip_h == false:
		knockbackDir.x *= -1
	else:
		pass
	animation.play("invicible")
	state = states.idle


func _on_area_puxao_body_entered(body: Node2D) -> void:
	if body.name == "boneco":
		await get_tree().create_timer(0.2).timeout
		var esquilo = get_parent().get_node("Boss_Esquilo")
		var tween = create_tween()
		tween.tween_property(self, "position", esquilo.position + Vector2(0, -16), 0.67)


func _on_area_de_colisão_area_entered(area: Area2D) -> void:
	if area.name == "TesteKnockback":
		state = states.knockback
	if area.name == "boss_area":
		state = states.knockback
	if area.name == "kill_zone":
		pass
	if area.name == "check_point":
		pass
