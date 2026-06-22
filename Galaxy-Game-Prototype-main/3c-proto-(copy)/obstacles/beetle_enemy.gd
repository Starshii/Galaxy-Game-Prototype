extends GravityObject

var CurWalkSpd : float = 1
var BaseWalkSpd : float = 10

var JumpVelV : float = 30
var JumpVelH : float = 10

var targetTransform : Vector3
var targetArea3D : Area3D

var inRange : bool

@onready var HitBox: Area3D = $HitBox
@onready var attackTimer: Timer = $Timer


func _ready() -> void:
	super._ready()
	CurGrav = 80
	
	
	
func _on_top_hit_box_area_entered(area: Area3D) -> void:
	print("ouch")
	if (area.is_in_group("Player")):
		area.Bounce(10,10)
		queue_free()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_instance_valid(targetArea3D):
		targetTransform = targetArea3D.global_position
		
	global_basis = Basis.looking_at(targetTransform - global_position, up_direction)



func _on_aggro_range_area_entered(area: Area3D) -> void:
	targetArea3D = area
	targetTransform = targetArea3D.global_position
	print(targetTransform)
	inRange = true
	attackTimer.start()
	print("in range")

func Jump():
	velocity = VectorUtil.make_perpendicular((targetTransform - global_position).normalized(), up_direction) * JumpVelH + up_direction * JumpVelV
	pass


func _on_timer_timeout() -> void:
	if targetTransform:
		targetTransform = targetArea3D.global_position
		Jump()


func _on_aggro_range_area_exited(_area: Area3D) -> void:
	attackTimer.stop()
	velocity = Vector3.ZERO
