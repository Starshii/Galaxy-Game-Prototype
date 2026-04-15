extends RayCast3D

var hit
func _physics_process(delta: float) -> void:
	if is_colliding():
		hit = get_collider()
		
