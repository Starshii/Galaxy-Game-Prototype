extends Control

var healthInt : int = 3

var healthArray : Array

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
