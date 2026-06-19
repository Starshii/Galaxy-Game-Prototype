extends Node

signal UpdateRotation(rotationvalue : Vector3)
signal UpdateButtons(currentbutton : String)
signal FadeInSignal
signal FadeOutSignal

var currentLevel : String
var hubornah : bool = true
var firstTime: bool = true

var unlocks = {
	"ceaselessbubbles" : false,
	"dragonflyplanet" : false,
	"ouroborosplanet" : false,
	"skyruins" : false
}

func _ready() -> void:
	if firstTime:
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
		hubornah = true
		get_tree().call_deferred("change_scene_to_file", "res://levels/hubworld.tscn")
	
	if currentLevel == "skyruins":
		hubornah = false
		print("main??")
		get_tree().change_scene_to_file("res://levels/main.tscn")
		
	if currentLevel == "ceaselessbubbles":
		get_tree().call_deferred("change_scene_to_file", "res://levels/wipscene.tscn")
		
	if currentLevel == "ouroborosplanet":
		get_tree().call_deferred("change_scene_to_file", "res://levels/wipscene.tscn")
		
	if currentLevel == "dragonflyplanet":
		get_tree().call_deferred("change_scene_to_file", "res://levels/wipscene.tscn")
		
		
func FadeIn():
	print("emitted")
	FadeInSignal.emit()

func FadeOut():
	print("emitted")
	FadeOutSignal.emit()

func UpdateUnlocks(interger : int):
	pass
	
