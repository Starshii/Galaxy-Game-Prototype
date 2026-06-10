@tool
class_name GravityArea extends Area3D

enum Type {
	Directional,
	ToPoint,
	FromPoint,
	ToLine,
	FromLine
}

@export var GravityType  : Type
@export var PriorityLink : GravityArea = self

var TruePriority : int

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() && GravityType == Type.Directional:
		DebugDraw3D.draw_arrow(global_position, global_position + gravity_direction.normalized()*30, Color.BLUE_VIOLET, 0.1, true, 0)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	TruePriority = priority


func _on_body_entered(body : Node3D):
	if body.is_in_group("Player"):
		TruePriority = priority
		if PriorityLink != self:
			body.AddGravityArea(self, true)
			PriorityLink.TruePriority = priority
			body.AddGravityAreaToFirst(PriorityLink)
		else:
			body.AddGravityArea(self, false)


func _on_body_exited(body : Node3D):
	if body.is_in_group("Player"):
		body.RemoveGravityArea(self)
