extends Node

signal UpdateRotation(rotationvalue : Vector3)
signal UpdateButtons(state : int)

@export var currentLevel : int = 1

func UpdateCurrentLevel(newLevel : int):
	currentLevel = newLevel
func RotateShip(rotationvalues : Vector3, currentButton : int):
	print("rotation to the guy thun")
	currentLevel = currentButton
	UpdateRotation.emit(rotationvalues)
	UpdateButtons.emit(currentButton)

func LoadLevel():
	if currentLevel == 0:
		get_tree().call_deferred("change_scene_to_file", "res://levels/hubworld.tscn")
	
	if currentLevel == 1:
		get_tree().change_scene_to_file("res://levels/main.tscn")
		
	if currentLevel == 2:
		print("level2")
		
	if currentLevel == 3:
		print("level3")
		
	if currentLevel == 4:
		print("level4")
