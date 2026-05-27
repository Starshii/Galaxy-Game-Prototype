extends Node3D

@export var root_3: Curve3D

func TiltRoot():
	var tween = create_tween()
	tween.tween_method(set_tilt, 0.0, deg_to_rad(180.0), 1.0)

func set_tilt(value):
	for i in range(root_3.point_count):
		root_3.set_point_tilt(i, value)
