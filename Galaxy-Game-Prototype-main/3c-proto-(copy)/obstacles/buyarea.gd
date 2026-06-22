extends Area3D

signal bought
signal unbought

var inArea : bool
@export var cost : int
@export var inlevel : bool
@export var unlockable : String
@export var mat : StandardMaterial3D
var mesh : MeshInstance3D


func _ready() -> void:
	mesh = get_child(1)
	mesh.material_overlay = mat
	if Levelmanager.unlocks.get(unlockable, true):
		print(str(unlockable)+ ": its true")
		mat.albedo_color = Color(0.0, 0.62, 0.91, 1.0)
		bought.emit()
	elif Levelmanager.unlocks.get(unlockable, false): 
		print(str(unlockable)+ ": its false")
		mat.albedo_color = Color(1.0, 0.265, 0.372, 1.0)
		unbought.emit()

func _on_area_entered(area: Area3D) -> void:
	inArea = true

func _on_area_exited(area: Area3D) -> void:
	inArea = false
	

func _process(delta: float) -> void:
	if inArea && Input.is_action_just_pressed("Confirm"):
		print("unlockable =", unlockable)
		print("value =", Levelmanager.unlocks.get(unlockable))
		if !Levelmanager.unlocks.get(unlockable, false) : 
			print("check currency and unlocks")
			if inlevel && CurrencyManager.levelEnergy >= cost:
				CurrencyManager.IncrementLevelEnergy(cost)
				print("bought t")
				Levelmanager.unlocks.set(unlockable,true)
				bought.emit()
				mat.albedo_color = Color(0.0, 0.62, 0.91, 1.0)
			elif !inlevel && CurrencyManager.totalEnergy>= cost:
				CurrencyManager.IncrementTotalEnergy(cost)
				print("bought t")
				Levelmanager.unlocks.set(unlockable,true)
				bought.emit()
				mat.albedo_color = Color(0.0, 0.62, 0.91, 1.0)
				
