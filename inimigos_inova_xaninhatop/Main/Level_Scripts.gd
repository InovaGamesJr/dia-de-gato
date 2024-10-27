extends Node2D

@onready var alarm: CollisionShape2D = $Awaken_Bats/Alarm

func _ready():
	for enemy_bat in $Enemys.get_children():
		if enemy_bat.has_method("bat_awaken"):
			alarm.connect("awaken_bats", Callable(enemy_bat, "bat_awaken"))
			print("Alarme conectado")
