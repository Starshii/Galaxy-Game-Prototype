extends AnimationPlayer




func BeamToShip():
	Levelmanager.firstTime = false
	CurrencyManager.UpdateTotalEnergy()
	CurrencyManager.levelEnergy = 0
	Levelmanager.UpdateCurrentLevel("hubworld")
	Levelmanager.LoadLevel()
