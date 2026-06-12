extends Area3D

@export var animator : AnimationPlayer






func _on_area_entered(area: Area3D) -> void:
	animator.play("launchstartup")
