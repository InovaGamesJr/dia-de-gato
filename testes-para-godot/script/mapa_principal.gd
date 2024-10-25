extends Node2D

@onready var player = get_node("boneco")
var cameras : bool = false
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if $"detecção/detector".is_colliding():
		player.camera = true
	if cameras == true:
		var tween = create_tween()
		tween.tween_property($boneco/Camera_Principal_Xand, "position", Vector2(261, -139), 6)

func _physics_process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	pass # Replace with function body.
