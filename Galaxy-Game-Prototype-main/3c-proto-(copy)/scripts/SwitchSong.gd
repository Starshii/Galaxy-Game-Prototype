extends AnimationPlayer

@export var songs = [Animation]

var canSwitch : bool

func CanSwitchSong():
	canSwitch=true

func SwitchTrack(song : String):
	if (canSwitch):
		play(song)
		canSwitch=false
