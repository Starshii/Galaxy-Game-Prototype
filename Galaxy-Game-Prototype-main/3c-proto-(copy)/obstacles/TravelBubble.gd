extends Area3D

@export var playernode: Player

@export var animationTime: float = 2
@export var pathfollow : PathFollow3D
@export var remote : RemoteTransform3D
var issoaring : bool

func _ready() -> void:
	issoaring = false

func _on_area_entered(area: Area3D) -> void:
	issoaring = true
	pathfollow.progress_ratio = 0
	remote.remote_path = playernode.get_path()
	playernode.ISSOARING()
	var tween = create_tween()
	
	tween.tween_property(remote, "rotation", Vector3(0,TAU * 12,0), 1)
	
	await tween.finished
	remote.rotation = Vector3.ZERO
	var tween3 = create_tween()
	tween3.tween_property(pathfollow, "progress_ratio", 1, animationTime)
	await tween3.finished
	remote.remote_path = ""
	playernode.ISSOARING()
