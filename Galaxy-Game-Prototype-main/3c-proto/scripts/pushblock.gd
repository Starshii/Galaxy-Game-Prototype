extends CharacterBody3D


func Push() -> void:
	position = position.move_toward(position + Vector3(-30,0,0), 9)

func PushBack() -> void:
	position = position.move_toward(position + Vector3(30,0,0), 9)
