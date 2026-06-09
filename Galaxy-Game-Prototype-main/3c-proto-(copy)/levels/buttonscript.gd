extends Node3D

@onready var area_3d: Area3D = $Area3D
@export var ButtonInt : int 
@export var RotationGiven : Vector3
@export var mat : StandardMaterial3D 
@onready var mesh: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	mesh.set_surface_override_material(0, mat)

func _on_area_3d_area_entered(area: Area3D) -> void:
	Levelmanager.RotateShip(RotationGiven)
	print("collidedwithbutton")
	mat.albedo_color = Color.AQUA
	area_3d.set_collision_mask_value(4, false)
