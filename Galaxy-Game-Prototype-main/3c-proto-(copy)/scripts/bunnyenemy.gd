class_name Bunny extends GravityObject


func _ready() -> void:
	gravity = 80
	velocity += VectorUtil.set_axis(velocity, global_basis.z * 20)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func JUMP() -> void:
	velocity = VectorUtil.set_axis(velocity, up_direction * 20)
