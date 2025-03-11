extends RigidBody2D

func _process(delta: float) -> void:
	var v = (get_global_mouse_position() - position).normalized() * 10
	apply_force(v)
	pass
