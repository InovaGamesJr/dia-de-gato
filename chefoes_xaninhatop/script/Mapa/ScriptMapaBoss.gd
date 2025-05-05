extends Node2D

var speed = 3

#Export das phantomCams
@export var pcamGato: PhantomCamera2D 
@export var pcamBoss: PhantomCamera2D
@export var pcamBossFight: PhantomCamera2D

#Export das entidades
@export var bossEsquilo : CharacterBody2D
@export var Gato : CharacterBody2D


@onready var going: Area2D = $Area2D




func _ready() -> void:
	pass

	
func _process(delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	pass


func zoom_to_boss(_body):
	#Toda a parte de camera na chegada do boss, pode ser mudada!!!
	$Area2D.queue_free()
	var player = $gato
	
	pcamBoss.set_tween_duration(3.5)
	pcamBoss.set_priority(20)
	await pcamBoss.tween_completed
	
	await get_tree().create_timer(0.5).timeout
	var boss = $Boss_Esquilo
	boss.state = boss.states.pulo
	
	await get_tree().create_timer(1.5).timeout
	pcamBossFight.set_tween_duration(1.5)
	pcamBoss.set_priority(0)
	pcamBossFight.set_priority(20)
	
	await pcamBossFight.tween_completed
	player.state = player.states.idle

	
