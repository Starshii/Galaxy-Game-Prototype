class_name Bunny extends GravityObject

var CurWalkSpd : float = 1
var BaseWalkSpd : float = 10


func _ready() -> void:
	super._ready()
	CurGrav = 80
	velocity += VectorUtil.set_axis(velocity, global_basis.z * 20)

func _physics_process(delta: float) -> void:
	velocity = VectorUtil.set_except_axis(velocity, FacingDir * BaseWalkSpd, up_direction)
	super._physics_process(delta)


func JUMP() -> void:
	velocity = VectorUtil.set_axis(velocity, up_direction * 20)
