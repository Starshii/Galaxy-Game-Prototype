extends Node3D

@onready var text: RichTextLabel = $SubViewport/Control/RichTextLabel
@export var cost : int
@export var desc: String
@export var inLevel: bool
var alreadybought : bool
var currentState : int
#0 = already bought, text is ""
#1 = enough currency to be bought, make blue
#2 = NOT enough currency to be bought, make red


func _ready() -> void:
	CurrencyManager.updateTotalEnergy.connect(CheckTotalCurrency)
	CurrencyManager.updateLevelEnergy.connect(CheckLevelCurrency)
	if inLevel:
		CheckLevelCurrency()
	else:
		CheckTotalCurrency()
	
	
func CheckTotalCurrency():
	if CurrencyManager.totalEnergy >= cost && !alreadybought:
		UpdateState(1)
	elif !alreadybought:
		UpdateState(2)
	
func CheckLevelCurrency():
	if CurrencyManager.levelEnergy >= cost && !alreadybought:
		UpdateState(1)
	elif !alreadybought:
		UpdateState(2)
	
func _on_buyarea_1_bought() -> void:
	print("signus")
	UpdateState(0)
	
func UpdateState(state : int):
	if state == 0:
		alreadybought = true
		hide()
	if state == 1:
		show()
		text.text = "[color=blue]" + str(cost) + "[img=16x16]" + "res://UI/boalbconceptshading.png" + "[/img] " + desc + "[/color]"
	if state == 2:
		show()
		text.text = "[color=red]" + str(cost) + "[img=16x16]" + "res://UI/boalbconceptshading.png" + "[/img] " + desc + "[/color]"
