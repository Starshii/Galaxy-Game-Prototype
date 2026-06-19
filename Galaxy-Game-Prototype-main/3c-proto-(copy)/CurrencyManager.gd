extends Node


var totalEnergy : int = 0
var levelEnergy : int = 0
signal updateTotalEnergy
signal updateLevelEnergy

func UpdateLevelEnergy(amount : int):
	print("updatedlevelenergy")
	levelEnergy += amount
	updateLevelEnergy.emit()
	
func IncrementTotalEnergy(amnt : int):
	totalEnergy -= amnt
	updateTotalEnergy.emit()
	
func IncrementLevelEnergy(amnt : int):
	levelEnergy -= amnt
	updateLevelEnergy.emit()
	
func UpdateTotalEnergy():
	totalEnergy += levelEnergy
	updateTotalEnergy.emit()


func loadscene():
	levelEnergy = 0
	print("loadscene")
	Levelmanager.UpdateCurrentLevel("hubworld")
	Levelmanager.LoadLevel()
	updateTotalEnergy.emit()
	updateLevelEnergy.emit()
