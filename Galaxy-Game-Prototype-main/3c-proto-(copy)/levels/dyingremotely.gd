extends RemoteTransform3D

@export var playerbody: CharacterBody3D


func DieRemotely():
	global_position = playerbody.global_position
