class_name StateMachine extends RefCounted

var current_state : State

func update(parent : Node, delta: float) -> void:
	assert(current_state != null, "Called \"update()\" on StateMachine, but there is no current state active.")
	
	var checks_done : int = 0
	var states_returned : Array[String]
	while true:
		if checks_done > 10:
			assert(false, "Did 10 checks to check state. This means a cyclical loop! Here's the rundown: %s" % str(states_returned))
			break
		var new_state = current_state.check_state(parent)
		checks_done += 1
		if new_state == null:
			break
		states_returned.append(new_state.name) 
		set_state(parent, new_state)
	
	current_state.update(parent, delta)

func set_state(parent : Node, new_state : State):
	if current_state != null:
		current_state.on_exit(parent)
	current_state = new_state
	current_state.on_enter(parent)
