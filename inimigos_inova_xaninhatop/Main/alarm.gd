extends CollisionShape2D
	
var wake_up : bool = false
	
func _on_awaken_bats_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		wake_up = true
	return wake_up
