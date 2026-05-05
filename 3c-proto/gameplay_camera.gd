class_name GameplayCamera extends Camera3D

const MIN_HEIGHT : float = 1
const MAX_HEIGHT : float = 10
const MIN_HORIZONTAL_DISTANCE : float = 3
const MAX_HORIZONTAL_DISTANCE : float = 8

const ROTATION_LINEAR_SPEED  : float = deg_to_rad(180)
const ROTATION_SMOOTH_FACTOR : float = 7
const POSITION_LINEAR_SPEED  : float = 100
const POSITION_SMOOTH_FACTOR : float = 6

var player : Player

var look_at_point : Vector3
var target_point_instant  : Vector3
var target_point_linear   : Vector3
var target_point_smoothed : Vector3

var up_direction_instant  : Vector3
var up_direction_linear   : Vector3
var up_direction_smoothed : Vector3


func _ready() -> void:
	player = get_tree().current_scene.find_child("Player")
	up_direction_instant = global_basis.y
	up_direction_linear = up_direction_instant
	up_direction_smoothed = up_direction_instant


func _physics_process(delta: float) -> void:
	if player == null:
		return
	  	
	if len(player.gravity_areas) == 0 || player.gravity_areas[0].type == GravityArea.Type.DirectionalGlobal:
		up_direction_instant = player.up_direction
	else:
		up_direction_instant = global_basis.y
	
	var height := VectorUtil.get_axis(global_position - player.global_position, player.up_direction)
	if height < MIN_HEIGHT:
		global_position += player.up_direction * (MIN_HEIGHT - height)
		height = MIN_HEIGHT
	if height > MAX_HEIGHT:
		global_position += player.up_direction * (MAX_HEIGHT - height)
		height = MAX_HEIGHT
	
	var horizontal_offset := VectorUtil.remove_axis(global_position - player.global_position, player.up_direction)
	if horizontal_offset.length_squared() > MAX_HORIZONTAL_DISTANCE * MAX_HORIZONTAL_DISTANCE:
		horizontal_offset = horizontal_offset.normalized() * MAX_HORIZONTAL_DISTANCE
	elif horizontal_offset.length_squared() < MIN_HORIZONTAL_DISTANCE * MIN_HORIZONTAL_DISTANCE:
		horizontal_offset = horizontal_offset.normalized() * MIN_HORIZONTAL_DISTANCE
	
	target_point_instant = player.global_position + horizontal_offset + height * player.up_direction
	look_at_point = player.global_position
	
	target_point_linear = target_point_linear.move_toward(target_point_instant, POSITION_LINEAR_SPEED * delta)
	target_point_smoothed = target_point_smoothed.lerp(target_point_linear, POSITION_SMOOTH_FACTOR * delta)
	
	var cam_rotate_axis_linear := up_direction_instant.cross(up_direction_linear)
	if cam_rotate_axis_linear.length_squared() < 0.01:
		cam_rotate_axis_linear = global_basis.z
	cam_rotate_axis_linear = cam_rotate_axis_linear.normalized()
	up_direction_linear = VectorUtil.smove_toward(up_direction_linear, up_direction_instant, cam_rotate_axis_linear, ROTATION_LINEAR_SPEED * delta)
	
	var cam_rotate_axis_smoothed := up_direction_linear.cross(up_direction_smoothed)
	if cam_rotate_axis_smoothed.length_squared() < 0.01:
		cam_rotate_axis_smoothed = global_basis.z
	cam_rotate_axis_smoothed = cam_rotate_axis_smoothed.normalized()
	up_direction_smoothed = VectorUtil.slerp(up_direction_smoothed, up_direction_linear, cam_rotate_axis_smoothed, ROTATION_SMOOTH_FACTOR * delta)
	
	global_position = target_point_smoothed
	global_basis = Basis.looking_at(look_at_point - global_position, up_direction_smoothed)
	
