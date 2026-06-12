extends AnimationPlayer




func BeamToShip():
	CurrencyManager.UpdateTotalEnergy()
	CurrencyManager.levelEnergy = 0
	Levelmanager.UpdateCurrentLevel("hubworld")
	Levelmanager.LoadLevel()
