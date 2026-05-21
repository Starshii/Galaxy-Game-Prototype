@abstract class_name State extends RefCounted

@abstract func check_state(this : Player) -> State
@abstract func update(this : Player, delta : float)
@abstract func on_enter(this : Player)
@abstract func on_exit(this : Player)


class NullState extends State:
	var name := "NullState"
	
	func check_state(_this : Player) -> State:
		return null
	
	func on_enter(_this : Player):
		pass
	
	func on_exit(_this : Player):
		pass
	
	func update(_this : Player, _delta : float):
		pass
