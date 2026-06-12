extends MeshInstance3D

@export var mymaterial : StandardMaterial3D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	rotation.y += delta * 1


func Locked():
	mymaterial.albedo_color = Color(0.0, 0.0, 0.6, 0.765)
	
func Unlocked():
	mymaterial.albedo_color = Color(0.0, 0.447, 0.592, 1.0)
