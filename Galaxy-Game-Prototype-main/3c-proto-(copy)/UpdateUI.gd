extends Control

var healthInt : int = 3

var healthArray : Array

var boalbCount : int
@onready var BoalbCounter: RichTextLabel = $BoalbCount

func _ready() -> void:
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

func _on_player_bounce_signal() -> void:
	pass
	
func _on_player_boalb_signal(amnt : int) -> void:
	boalbCount += amnt
	UpdateBoalb()
	
func UpdateBoalb():
	BoalbCounter.text = "Energy: " + str(boalbCount)
