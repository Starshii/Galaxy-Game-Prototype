extends Node3D

@onready var area_3d: Area3D = $Area3D
@export var RotationGiven : Vector3
@export var mat : StandardMaterial3D 
@onready var mesh: MeshInstance3D = $MeshInstance3D
@export var stateInt : int
@export var myButtonNumber : int

func _ready() -> void:
	mesh.set_surface_override_material(0, mat)
	UpdateButtonState(stateInt)
	Levelmanager.UpdateButtons.connect(LevelSelect)

func _on_area_3d_area_entered(area: Area3D) -> void:
	print("collidedwithbutton")
	Levelmanager.RotateShip(RotationGiven, myButtonNumber)

func LevelSelect(currentLevel : int):
	if currentLevel == myButtonNumber:
		UpdateButtonState(2)
	elif stateInt != 0: 
		UpdateButtonState(1)

func UpdateButtonState(currentstate : int):
	
	if currentstate == 0:
		mat.albedo_color = Color.DIM_GRAY
		area_3d.set_collision_mask_value(4, false)
		
	if currentstate == 1: 
		mat.albedo_color = Color.DARK_CYAN
		area_3d.set_collision_layer_value(4, true)
		
	if currentstate == 2: 
		mat.albedo_color = Color.AQUA
		area_3d.set_collision_layer_value(4, false)
