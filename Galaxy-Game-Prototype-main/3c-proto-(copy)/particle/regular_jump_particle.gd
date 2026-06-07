extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void: 
	
	animation_player.play("regularparticle")
	
	await animation_player.animation_finished
	print("go tther")
	queue_free()
