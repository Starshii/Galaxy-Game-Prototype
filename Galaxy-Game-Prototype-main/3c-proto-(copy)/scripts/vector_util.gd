class_name VectorUtil extends Node

## Returns the length of the vector along the axis
static func get_axis(vector : Vector3, axis : Vector3) -> float:
	return vector.dot(axis.normalized())


## Returns the part of the vector that's along the axis.
static func get_axis_vector(vector : Vector3, axis : Vector3) -> Vector3:
	return axis * vector.dot(axis) / axis.length_squared()


## Returns the vector, with its length along the axis being set to 0.
static func remove_axis(vector : Vector3, axis : Vector3) -> Vector3:
	return vector - get_axis_vector(vector, axis)


## Returns vector, with its length along the axis being the length of "axis" itself.
static func set_axis(vector : Vector3, axis : Vector3) -> Vector3:
	return remove_axis(vector, axis) + axis


## Takes a vector, and returns the closest vector that is perpendicular to perpendicular_to.
## It also sets its length to 1! That's more useful than whatever length it produces.
static func make_perpendicular(vector : Vector3, perpendicular_to : Vector3) -> Vector3:
	return remove_axis(vector, perpendicular_to).normalized()


## Maybe I can explain this function better if I've used it for a bit.
static func set_except_axis(vector : Vector3, to_set : Vector3, axis_to_ignore : Vector3) -> Vector3:
	return to_set + get_axis_vector(vector, axis_to_ignore)


## The built-in cross function, but with the VectorUtil syntax.
static func cross(a : Vector3, b : Vector3) -> Vector3:
	return a.cross(b)


static func smove_toward(a : Vector3, b : Vector3, axis : Vector3, delta : float) -> Vector3:
	var angle_diff := a.signed_angle_to(b, axis)
	if abs(angle_diff) <= delta:
		return b
	else:
		var result := a.rotated(axis, sign(angle_diff) * delta)
		var new_angle_diff := result.signed_angle_to(b, axis)
		if sign(new_angle_diff) != sign(angle_diff):
			return b
		return result


static func slerp(a : Vector3, b : Vector3, axis : Vector3, t : float) -> Vector3:
	var angle_diff := a.signed_angle_to(b, axis)
	var result := a.rotated(axis, angle_diff * t)
	var new_angle_diff := result.signed_angle_to(b, axis)
	if sign(angle_diff) != sign(new_angle_diff):
		return b
	return result

static func project_on_line(line_point : Vector3, line_vector : Vector3, point : Vector3) -> Vector3:
	var local_point := point - line_point
	line_vector = line_vector.normalized()
	return line_point + line_vector * line_vector.dot(local_point)
