extends Area3D


var inArea:bool
@export var cost : int

func _on_area_entered(area: Area3D) -> void:
	inArea=true
	

func _on_area_exited(area: Area3D) -> void:
	inArea=false
	

func _process(delta: float) -> void:
	if inArea && Input.is_action_just_pressed("Confirm"):
		CurrencyManager.totalEnergy -= cost
		CurrencyManager.UpdateTotalEnergy()
