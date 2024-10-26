extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -350.0
const Gravity = 1000
const max_jumps = 2
var number_jumps = 0

func _ready():
	Global.playerBody = self

func _physics_process(delta: float):
	# Add the gravity.d
	if not is_on_floor():
		velocity.y += Gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		number_jumps += 1
	elif Input.is_action_just_pressed("Jump") and !is_on_floor() and number_jumps < 2:
		velocity.y = JUMP_VELOCITY
		number_jumps += 1
	if is_on_floor() and number_jumps >= 2:
		number_jumps = 0
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
