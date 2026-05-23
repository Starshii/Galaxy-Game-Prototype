@tool
extends CSGBox3D

@export var target_sphere: CSGSphere3D


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return
	if not target_sphere:
		return
	if not is_inside_tree():
		return
	
	var space_state := get_world_3d().direct_space_state
	if not space_state:
		return
	
	var origin: Vector3 = global_position
	var sphere_center: Vector3 = target_sphere.global_position
	
	var direction: Vector3 = (sphere_center - origin).normalized()
	if direction.is_zero_approx():
		return
	
	# Cast from this object toward the sphere center
	var query := PhysicsRayQueryParameters3D.create(
		origin,
		sphere_center,
		0xFFFFFFFF,          # collision mask — all layers
		[self]               # exclude self
	)
	query.hit_from_inside = true
	
	var result: Dictionary = space_state.intersect_ray(query)
	if result.is_empty():
		return
	
	var hit_normal: Vector3 = result["normal"]
	
	# Rotate the box so its local +Y aligns away from the hit surface normal
	# (change Vector3.UP to whichever local axis you want pointing "away")
	if hit_normal.is_zero_approx():
		return
	
	var away: Vector3 = -hit_normal          # direction to face away from surface
	var up_ref: Vector3 = Vector3.UP
	
	# Avoid degenerate basis when away is parallel to up_ref
	if abs(away.dot(up_ref)) > 0.99:
		up_ref = Vector3.FORWARD
	
	var new_basis := Basis.looking_at(away, up_ref)
	global_transform.basis = new_basis
