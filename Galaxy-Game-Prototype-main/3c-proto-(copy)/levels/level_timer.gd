extends Timer




func _on_timeout() -> void:
	CurrencyManager.UpdateTotalEnergy()
	CurrencyManager.levelEnergy = 0
	Levelmanager.UpdateCurrentLevel(0)
	Levelmanager.LoadLevel()
