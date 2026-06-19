extends RemoteTransform3D

@export var playernode: Player
func SetTransform():
	print("settransform")
	rotation = playernode.global_rotation
	global_position = playernode.global_position
	remote_path = playernode.get_path()

func UnSetTransform():
	remote_path = ""
