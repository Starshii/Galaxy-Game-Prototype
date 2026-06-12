extends AnimatableBody3D

var rotatetowards : Vector3

func _ready() -> void:
	Levelmanager.UpdateRotation.connect(RotateShip)
	
	if Levelmanager.firstTime:
		rotation.y = -40

func RotateShip(rotateto : Vector3):
	var tween = create_tween()
	tween.tween_property(self, "rotation", Vector3(deg_to_rad(rotateto.x),deg_to_rad(rotateto.y),deg_to_rad(rotateto.z)), 5)
	
	
