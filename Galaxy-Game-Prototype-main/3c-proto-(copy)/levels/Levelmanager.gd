extends Node

signal UpdateRotation(rotationvalue : Vector3)
signal UpdateButtons(currentbutton : String)

var currentLevel : String
var hubornah : bool = true

@export var ceaselessbubbleint: int = 1
@export var dragonflyplanetint: int = 1
@export var ouroborosplanetint: int = 1

var unlocks = {
	"ceaselessbubbles" : false,
	"dragonflyplanet" : false,
	"ouroborosplanet" : false,
	"skyruins" : false
}

func _ready() -> void:
	currentLevel = "skyruins"
	pass


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
		get_tree().change_scene_to_file("res://levels/main.tscn")
		
	if currentLevel == "ceaselessbubbles":
		get_tree().call_deferred("change_scene_to_file", "res://levels/wipscene.tscn")
		
	if currentLevel == "ouroborosplanet":
		get_tree().call_deferred("change_scene_to_file", "res://levels/wipscene.tscn")
		
	if currentLevel == "dragonflyplanet":
		get_tree().call_deferred("change_scene_to_file", "res://levels/wipscene.tscn")
		
		
		
func UpdateUnlocks(interger : int):
	pass
	
