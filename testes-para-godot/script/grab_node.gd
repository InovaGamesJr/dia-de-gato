extends Node2D


@onready var boneco = get_parent().get_parent().get_node("boneco/Marker2D")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_grab_timeout() -> void:
	look_at(boneco.global_position)