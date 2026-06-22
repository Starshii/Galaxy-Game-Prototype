extends Node

signal UpdateRotation(rotationvalue : Vector3)
signal UpdateButtons(currentbutton : String)
signal FadeInSignal
signal FadeOutSignal
signal nightfall

var currentLevel : String
var hubornah : bool = true
var firstTime: bool = true

var unlocks = {
	"ceaselessbubbles" : false,
	"dragonflyplanet" : false,
	"ouroborosplanet" : false,
	"skyruins" : false,
	"statue1" : false,
	"statue2" : false,
	"statue3" : false,
	"statue4" : false,
	"statue5" : false,
	"statue6" : false,
	"statue7" : false,
	"statue8" : false,
	"boulder" : false,
	"launchbubble1" : false
}

func _ready() -> void:
	if firstTime:
		CurrencyManager.CurrencySwitch(true)
		currentLevel = "hubworld"
	else:
		currentLevel = "skyruins"

func UpdateCurrentLevel(newLevel : String):
	currentLevel = newLevel
	
func RotateShip(rotationvalues : Vector3, currentButton : String):
	currentLevel = currentButton
	UpdateRotation.emit(rotationvalues)
	UpdateButtons.emit(currentButton)


func LoadLevel():
	if currentLevel == "hubworld":
		CurrencyManager.CurrencySwitch(true)
		hubornah = true
		get_tree().call_deferred("change_scene_to_file", "res://levels/hubworld.tscn")
	
	if currentLevel == "skyruins":
		CurrencyManager.CurrencySwitch(false)
		hubornah = false
		get_tree().change_scene_to_file("res://levels/main.tscn")
		
	if currentLevel == "ceaselessbubbles":
		get_tree().call_deferred("change_scene_to_file", "res://levels/wipscene.tscn")
		
	if currentLevel == "ouroborosplanet":
		get_tree().call_deferred("change_scene_to_file", "res://levels/wipscene.tscn")
		
	if currentLevel == "dragonflyplanet":
		get_tree().call_deferred("change_scene_to_file", "res://levels/wipscene.tscn")
		
		
func FadeIn():
	FadeInSignal.emit()

func FadeOut():
	FadeOutSignal.emit()
	
func NightFall():
	nightfall.emit()
