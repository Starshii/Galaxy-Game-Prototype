extends Node

signal UpdateRotation(rotationvalue : Vector3)

var currentLevel : int

func UpdateCurrentLevel(currentlevels : int):
	currentLevel = currentlevels

func RotateShip(rotationvalues : Vector3):
	print("rotation to the guy thun")
	UpdateRotation.emit(rotationvalues)

func LoadLevel():
	get_tree().change_scene_to_file("res://levels/main.tscn")
