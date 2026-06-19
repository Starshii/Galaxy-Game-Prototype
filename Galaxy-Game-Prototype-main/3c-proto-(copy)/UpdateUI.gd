extends Control

var healthInt : int = 3

var healthArray : Array

var levelboalbCount : int
var totalBoalbCount : int
@onready var LevelBoalbCounter: RichTextLabel = $BoalbCount
@onready var TotalBoalbCounter: RichTextLabel = $BoalbCountTotal
@onready var whiteout: ColorRect = $whiteout

@export var animator : AnimationPlayer

func _ready() -> void:
	Levelmanager.FadeOutSignal.connect(FadeOutFunc)
	Levelmanager.FadeInSignal.connect(FadeInFunc)
	if Levelmanager.hubornah:
		LevelBoalbCounter.hide()
		TotalBoalbCounter.show()
	else:
		LevelBoalbCounter.show()
		TotalBoalbCounter.hide()
	
	UpdateLevelBoalb()
	UpdateTotalBoalb()
	CurrencyManager.updateTotalEnergy.connect(UpdateTotalBoalb)
	CurrencyManager.updateLevelEnergy.connect(UpdateLevelBoalb)
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
		animator.play("dying")
		
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
	LevelBoalbCounter.text = "Level Energy: " + str(CurrencyManager.levelEnergy)
	
func UpdateTotalBoalb():
	TotalBoalbCounter.text = "Total Energy: " + str(CurrencyManager.totalEnergy)
	
func FadeInFunc():
	whiteout.color = Color(1.0, 1.0, 1.0, 1.0)
	var tween = create_tween()
	tween.tween_property(whiteout, "color", Color(1.0, 1.0, 1.0, 0.0), 1)

func FadeOutFunc():
	whiteout.color = Color(0.0, 0.0, 0.0, 0.0)
	var tween = create_tween()
	tween.tween_property(whiteout, "color", Color(1.0, 1.0, 1.0, 1.0), 1)
