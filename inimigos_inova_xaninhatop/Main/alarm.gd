extends CollisionShape2D

signal awaken_bats

func _on_awaken_bats_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Sinal Emitido")
		emit_signal("awaken_bats")
		set_deferred("disabled", true)
		print("Colisao desativada")
