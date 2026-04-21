class_name GravityArea extends Area3D

enum Type {
	Directional,
	ToPoint,
	FromPoint,
}

@export var type : Type

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body : Node3D):
	if body.has_method("add_gravity_area"):
		body.add_gravity_area(self)


func _on_body_exited(body : Node3D):
	if body.has_method("remove_gravity_area"):
		body.remove_gravity_area(self)
