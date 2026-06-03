extends Area3D

var my_player : CharacterBody3D

func _ready() -> void:
	my_player = get_parent()

func Bounce(Hor : float, Ver: float):
	my_player.Bounce(Hor,Ver)
