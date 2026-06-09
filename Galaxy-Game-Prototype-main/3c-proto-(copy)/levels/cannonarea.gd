extends Area3D

@onready var initialTimer: Timer = $InitialTimer
@onready var loadTimer: Timer = $LoadLevelTimer

@export var vert : float
var hor : float
var playerarea : Area3D

func _on_area_entered(area: Area3D) -> void:
	playerarea = area
	initialTimer.start()


func _on_initial_timer_timeout() -> void:
	playerarea.Bounce(hor, vert)
	loadTimer.start()


func _on_load_level_timer_timeout() -> void:
	Levelmanager.LoadLevel()
