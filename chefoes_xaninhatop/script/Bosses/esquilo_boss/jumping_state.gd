extends StateEsquilo

@export var attack_1 : StateEsquilo

var nuts = preload("res://scenes/nuts_bullet.tscn")
var is_jumping : bool

func on_enter():
	playback.travel("jumping")


func jumping():
	character.velocity.y = -110
	is_jumping = true
	await get_tree().create_timer(3.0).timeout
	$"../../AnimationPlayer".play("new_animation")
	
func jumping_2():
	character.velocity.x = -100
	character.velocity.y = -70
	
func shoot():
	var Nuts = nuts.instantiate()
	var vetor : Vector2 = character.global_position
	Nuts.global_position = vetor + Vector2(0, 18)
	get_parent().get_parent().get_parent().add_child(Nuts)
	
