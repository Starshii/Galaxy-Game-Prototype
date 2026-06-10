extends Area3D

@export var BoalbAmount : int


func _on_area_entered(_area: Area3D) -> void:
	queue_free()
