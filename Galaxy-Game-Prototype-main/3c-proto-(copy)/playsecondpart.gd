extends Area3D

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"



func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("bounceable"):
		animation_player.CanSwitchSong()
