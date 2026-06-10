extends Node


var totalEnergy : int
var levelEnergy : int
signal updateTotalEnergy
signal updateLevelEnergy

func _ready() -> void:

	print("total energy: " + str(totalEnergy))
	print("level energy: " + str(levelEnergy))

func UpdateLevelEnergy(amount : int):
	print("updatedlevelenergy")
	levelEnergy += amount

func UpdateTotalEnergy():
	totalEnergy += levelEnergy
	updateTotalEnergy.emit()
	print("updatedtotalenergy")
	print("total energy: " + str(totalEnergy))
	print("level energy: " + str(levelEnergy))


func loadscene():
	levelEnergy = 0
	print("loadscene")
	Levelmanager.UpdateCurrentLevel(0)
	Levelmanager.LoadLevel()
