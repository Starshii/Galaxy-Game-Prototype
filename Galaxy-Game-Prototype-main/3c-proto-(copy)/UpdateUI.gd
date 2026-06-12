extends Control

var healthInt : int = 3

var healthArray : Array

var levelboalbCount : int
var totalBoalbCount : int
@onready var LevelBoalbCounter: RichTextLabel = $BoalbCount
@onready var TotalBoalbCounter: RichTextLabel = $BoalbCountTotal

func _ready() -> void:
	if Levelmanager.hubornah:
		LevelBoalbCounter.hide()
		TotalBoalbCounter.show()
	else:
		LevelBoalbCounter.show()
		TotalBoalbCounter.hide()
	
	UpdateLevelBoalb()
	UpdateTotalBoalb()
	CurrencyManager.updateTotalEnergy.connect(UpdateTotalBoalb)
	healthArray = get_children()
	healthInt = 3
	UpdateHealth(healthInt)
	
	
func _on_player_change_health(amnt : int) -> void:
	healthInt += amnt
	UpdateHealth(healthInt)


func UpdateHealth(amount :int):
	
	if healthInt == 3:
		healthArray[0].hide()
		healthArray[1].hide()
		healthArray[2].show()

	if healthInt == 2:
		healthArray[0].hide()
		healthArray[1].show()
		healthArray[2].hide()
		

	if healthInt == 1:
		healthArray[0].show()
		healthArray[1].hide()
		healthArray[2].hide()
		

	if healthInt < 1:
		print("ded lmao")
		
	if healthInt > 3:
		healthInt = 3
		UpdateHealth(healthInt)
	
func _on_player_boalb_signal(amnt : int) -> void:
	CurrencyManager.UpdateLevelEnergy(amnt)
	UpdateLevelBoalb()
	UpdateTotalBoalb()

func _on_currencymanager_update_level_energy() -> void:
	UpdateLevelBoalb()
	UpdateTotalBoalb()

func _on_currencymanager_update_total_energy() -> void:
	UpdateLevelBoalb()
	UpdateTotalBoalb()

func UpdateLevelBoalb():
	LevelBoalbCounter.text = "Energy " + str(CurrencyManager.levelEnergy)
	
func UpdateTotalBoalb():
	TotalBoalbCounter.text = "Energy: " + str(CurrencyManager.totalEnergy)
