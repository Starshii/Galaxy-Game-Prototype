extends Node3D

@onready var area_3d: Area3D = $Area3D
@onready var buyarea: Area3D = $buyarea

@export var RotationGiven : Vector3
@export var mat : StandardMaterial3D 
@onready var mesh: MeshInstance3D = $MeshInstance3D
@export var stateInt : int
@export var mylevel : String
var inbuyarea : bool
@export var cost : int

func _ready() -> void:
	mesh.set_surface_override_material(0, mat)
	UpdateButtonState(stateInt)
	Levelmanager.UpdateButtons.connect(LevelSelect)

func _on_area_3d_area_entered(area: Area3D) -> void:
	Levelmanager.RotateShip(RotationGiven, mylevel)

func LevelSelect(currentLevel : String):
	if currentLevel == mylevel:
		UpdateButtonState(2)
	
	elif stateInt == 2:
		UpdateButtonState(1)
	
	elif stateInt != 0: 
		UpdateButtonState(1)

func UpdateButtonState(currentstate : int):
	if currentstate == 0:
		mat.albedo_color = Color.DIM_GRAY
		area_3d.set_collision_mask_value(4, false)
		buyarea.set_collision_mask_value(4, true)
		stateInt = 0
		
		
	if currentstate == 1: 
		mat.albedo_color = Color.DARK_CYAN
		area_3d.set_collision_mask_value(4, true)
		buyarea.set_collision_mask_value(4, false)
		stateInt = 1
		
	if currentstate == 2: 
		mat.albedo_color = Color.AQUA
		area_3d.set_collision_mask_value(4, false)
		buyarea.set_collision_mask_value(4, false)
		stateInt = 2


func _process(_delta: float) -> void:
	if inbuyarea:
		if Input.is_action_just_pressed("Confirm"):
			if CurrencyManager.totalEnergy >= cost:
				if Levelmanager.unlocks.get(mylevel, false) == false:
					CurrencyManager.IncrementTotalEnergy(cost)
					Levelmanager.unlocks[mylevel] = true
					Levelmanager.RotateShip(RotationGiven, mylevel)
					

func _on_buyarea_area_entered(_area: Area3D) -> void:
	inbuyarea = true


func _on_buyarea_area_exited(_area: Area3D) -> void:
	inbuyarea = false


func _on_level_manager_update_buttons(currentbutton : String) -> void:
	LevelSelect(currentbutton)
