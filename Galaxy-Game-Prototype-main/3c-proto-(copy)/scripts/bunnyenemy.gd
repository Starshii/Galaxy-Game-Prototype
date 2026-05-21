class_name Bunny extends GravityObject


func _ready() -> void:
	CurGrav = 80
	velocity += VectorUtil.set_axis(velocity, global_basis.z * 20)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func JUMP() -> void:
	DirInput = Vector2(2,0)
	velocity = VectorUtil.set_axis(velocity, up_direction * 20)
