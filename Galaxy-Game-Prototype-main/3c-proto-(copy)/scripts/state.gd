@abstract class_name State extends RefCounted

@abstract func check_state(this : Node) -> State
@abstract func update(this : Node, delta : float)
@abstract func on_enter(this : Node)
@abstract func on_exit(this : Node)


class NullState extends State:
	var name := "NullState"
	
	func check_state(_this : Node) -> State:
		return null
	
	func on_enter(_this : Node):
		pass
	
	func on_exit(_this : Node):
		pass
	
	func update(_this : Node, _delta : float):
		pass
