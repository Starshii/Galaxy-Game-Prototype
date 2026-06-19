extends Area3D

signal bought

var inArea:bool
@export var cost : int
@export var inlevel : bool

func _on_area_entered(area: Area3D) -> void:
	inArea=true
	

func _on_area_exited(area: Area3D) -> void:
	inArea=false
	

func _process(delta: float) -> void:
	if inArea && Input.is_action_just_pressed("Confirm"):
		if inlevel && CurrencyManager.levelEnergy >= cost: 
			CurrencyManager.IncrementLevelEnergy(cost)
			bought.emit()
		elif CurrencyManager.totalEnergy >= cost:
			CurrencyManager.IncrementTotalEnergy(cost)
			bought.emit()
