class_name GravityArea extends Area3D

enum Type {
	DirectionalGlobal,
	DirectionalLocal,
	ToPoint,
	FromPoint,
	FromLine,
}

@export_flags_3d_physics var player : int = 2
@export var type          : Type
@export var gravity_value : Vector3 = Vector3.DOWN

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	collision_mask = player


func _on_body_entered(body : Node3D):
	if body.has_method("add_gravity_area"):
		body.add_gravity_area(self)


func _on_body_exited(body : Node3D):
	if body.has_method("remove_gravity_area"):
		body.remove_gravity_area(self)
