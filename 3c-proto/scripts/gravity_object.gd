class_name GravityObject extends CharacterBody3D

const MAX_VELOCITY : float = 80.0
const DEFAULT_GRAVITY : float = 40.0

const UP_DIRECTION_LINEAR_SPEED : float = deg_to_rad(360 * 2)
const UP_DIRECTION_SMOOTH_SPEED  : float = 5

var up_direction_visual_instant  : Vector3
var up_direction_visual_linear   : Vector3
var up_direction_visual_smoothed : Vector3

var on_ground     : bool
var last_velocity : Vector3

var update_up_direction : bool = true
var update_basis        : bool = true

var gravity_area_changed : bool
var current_gravity_area : GravityArea
var gravity_areas : Array[GravityArea]
var gravity : float = DEFAULT_GRAVITY

func _ready() -> void:
	pass


func add_gravity_area(gravity_area : GravityArea) -> void:
	gravity_areas.push_front(gravity_area)
	var new_area_index : int = 0
	while len(gravity_areas) > new_area_index + 1 && gravity_areas[new_area_index].priority < gravity_areas[new_area_index + 1].priority:
		var swap : GravityArea = gravity_areas[new_area_index + 1]
		gravity_areas[new_area_index + 1] = gravity_areas[new_area_index]
		gravity_areas[new_area_index] = swap


func remove_gravity_area(gravity_area : GravityArea) -> void:
	gravity_areas.erase(gravity_area)


func _physics_process(delta: float) -> void:
	gravity_area_changed = false
	if len(gravity_areas) > 0:
		if gravity_areas[0] != current_gravity_area:
			gravity_area_changed = true
			current_gravity_area = gravity_areas[0]
	
	if update_up_direction && current_gravity_area != null:
		match current_gravity_area.type:
			GravityArea.Type.DirectionalGlobal:
				up_direction = -current_gravity_area.gravity_value.normalized()
			GravityArea.Type.DirectionalLocal:
				up_direction = current_gravity_area.global_basis * -current_gravity_area.gravity_value
			GravityArea.Type.ToPoint:
			
				var gravity_middle := current_gravity_area.to_global(current_gravity_area.gravity_value)
				up_direction = (global_position - gravity_middle).normalized()
			GravityArea.Type.FromPoint:
				var gravity_middle := current_gravity_area.to_global(current_gravity_area.gravity_value)
				up_direction = -(global_position - gravity_middle).normalized()
			GravityArea.Type.FromLine: 
				var line_vector_global := current_gravity_area.global_basis * current_gravity_area.gravity_value
				var gravity_middle := VectorUtil.project_on_line(current_gravity_area.global_position, line_vector_global, global_position)
				up_direction = (gravity_middle - global_position).normalized()
			_: assert(false, "Gravity area \"%s\" is not yet implemented" % GravityArea.Type.find_key(current_gravity_area.type))
	#DebugDraw3D.draw_line(global_position, global_position + up_direction, Color.GREEN)
	
	velocity -= up_direction * gravity * delta
	
	if update_basis:
		global_basis.y = up_direction
		global_basis.z = VectorUtil.make_perpendicular(global_basis.z, up_direction)
		global_basis.x = up_direction.cross(global_basis.z)
	
	if velocity.length_squared() > MAX_VELOCITY * MAX_VELOCITY:
		velocity = velocity.normalized() * MAX_VELOCITY
	
	last_velocity = velocity
	move_and_slide()
	on_ground = is_on_floor()
	
	#DebugDraw3D.draw_line(global_position, global_position + velocity, Color.YELLOW)
	#DebugDraw3D.draw_line(global_position, global_position + global_basis.x, Color.RED)
	#DebugDraw3D.draw_line(global_position, global_position + global_basis.y, Color.GREEN)
	#DebugDraw3D.draw_line(global_position, global_position + global_basis.z, Color.BLUE)
