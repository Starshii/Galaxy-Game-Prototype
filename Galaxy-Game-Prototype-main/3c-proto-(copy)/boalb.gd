extends Area3D

var timer : float
var pos : Vector3 

func _ready() -> void:
	pos = global_position

func _physics_process(delta: float) -> void:
	timer += delta
	position.y = pos.y + sin(timer)
