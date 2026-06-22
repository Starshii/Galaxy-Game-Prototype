extends Node

var totalEnergy : int = 0
var levelEnergy : int = 0
signal updateTotalEnergy
signal updateLevelEnergy

		
func CurrencySwitch(hubornah : bool):
	if hubornah:
		print("hub")
		totalEnergy += levelEnergy
		levelEnergy = 0
		updateTotalEnergy.emit()
	else: 
		levelEnergy = 0
		updateLevelEnergy.emit()
		print("level")
		
	print("level energy" + str(levelEnergy))
	print("total energy" + str(totalEnergy))

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
	print("loadscene")
	Levelmanager.UpdateCurrentLevel("hubworld")
	Levelmanager.LoadLevel()
	updateTotalEnergy.emit()
	updateLevelEnergy.emit()
