extends Node


func _on_bought() -> void:
	print("bought")
	get_child(0).show()
	get_child(1).hide()



func _on_unbought() -> void:
	print("unbought")
	get_child(0).hide()
	get_child(1).show()
