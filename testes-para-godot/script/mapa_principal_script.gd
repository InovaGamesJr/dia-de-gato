extends Node2D

var speed = 3
@onready var pcam_boneco: PhantomCamera2D = $boneco/Pcam_boneco
@onready var pcam_boss: PhantomCamera2D = $Boss_Esquilo/Pcam_boss
@onready var going: Area2D = $Area2D
@onready var pcam_meio: PhantomCamera2D = $camera_meio/Pcam_meio




func _ready() -> void:
	going.body_entered.connect(zoom_to_boss)

	
func _process(delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	pass


func zoom_to_boss(_body):

	$Area2D.queue_free()
	var player = $boneco
	player.state = player.States.waiting
	
	pcam_boss.set_tween_duration(3.5)
	pcam_boss.set_priority(20)
	await pcam_boss.tween_completed
	
	await get_tree().create_timer(1.0).timeout
	var boss = $Boss_Esquilo
	
	await get_tree().create_timer(1.5).timeout
	pcam_meio.set_tween_duration(1.5)
	pcam_boss.set_priority(0)
	pcam_meio.set_priority(20)
	
	await pcam_meio.tween_completed
	player.state = player.States.idle
	boss.state = boss.states.pulo
	