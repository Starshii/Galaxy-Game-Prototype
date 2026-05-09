class_name Player extends CharacterBody3D

const MAX_VELOCITY : float = 80.0
const DEFAULT_GRAVITY : float = 40.0

const INPUT_CHANGE_ANGLE : float = deg_to_rad(5)

const UP_DIRECTION_LINEAR_SPEED : float = deg_to_rad(360 * 2)
const UP_DIRECTION_SMOOTH_SPEED  : float = 15

const WALK_MAX_SPEED         : float = 12.0
const WALK_ACCELERATION      : float = 30.0
const WALK_DECELERATION      : float = 30.0
const WALK_SKID_ACCELERATION : float = 60.0
const WALK_SKID_ANGLE        : float = -cos(deg_to_rad(45))
const WALK_TURN_SPEED        : float = deg_to_rad(360.0 * 2)
const WALK_TURN_SMOOTHING    : float = 15

const APEX_START_VELOCITY : float = 2.0
const APEX_END_VELOCITY   : float = -2.0
const APEX_TIME           : float = 0.1
const APEX_GRAVITY        : float = 20.0

const JUMP_VELOCITY = 20
const JUMP_MIN_VELOCITY = 3
const JUMP_GRAVITY = 80.0
const AIR_ACCELERATION = 30.0
const AIR_TURN_SPEED = deg_to_rad(360.0 * 1)
const AIR_TURN_SMOOTHING = 15

var state_machine : StateMachine = StateMachine.new()

var directional_input         : Vector2
var directional_input_camera  : Vector3
var directional_input_player  : Vector3

var up_direction_linear   : Vector3
var up_direction_smoothed : Vector3

var facing_direction : Vector3
var facing_direction_smoothed : Vector3
var on_ground : bool

var current_gravity_area : GravityArea
var gravity_areas : Array[GravityArea]
var gravity : float

func _ready() -> void:
	facing_direction = -global_basis.z
	facing_direction_smoothed = facing_direction
	up_direction = Vector3.UP
	up_direction_linear = up_direction
	up_direction_smoothed = up_direction_linear
	facing_direction = Vector3.FORWARD
	velocity = Vector3.ZERO
	gravity = DEFAULT_GRAVITY
	state_machine.set_state(self, PlayerGroundState.new())


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
	if len(gravity_areas) > 0:
		current_gravity_area = gravity_areas[0]
	
	if current_gravity_area != null:
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
				up_direction = -(global_position- gravity_middle).normalized()
			GravityArea.Type.FromLine:
				var gravity_middle := VectorUtil.project_on_line(current_gravity_area.global_position, current_gravity_area.gravity_value, global_position)
				up_direction = (gravity_middle - global_position).normalized()
			_: assert(false, "Gravity area \"%s\" is not yet implemented" % GravityArea.Type.find_key(current_gravity_area.type))
		facing_direction = VectorUtil.make_perpendicular(facing_direction, up_direction)
	
	#DebugDraw3D.draw_line(global_position, global_position + up_direction, Color.GREEN)
	
	velocity -= up_direction * gravity * delta
	
	var up_direction_linear_axis := up_direction_linear.cross(up_direction)
	if up_direction_linear_axis.length_squared() > 0.01:
		up_direction_linear_axis = up_direction_linear_axis.normalized()
		up_direction_linear = VectorUtil.smove_toward(up_direction_linear, up_direction, up_direction_linear_axis, delta * UP_DIRECTION_LINEAR_SPEED)
	else:
		up_direction_linear = up_direction
	
	var up_direction_smoothed_axis := up_direction_smoothed.cross(up_direction_linear)
	if up_direction_smoothed_axis.length_squared() > 0.01:
		up_direction_smoothed_axis = up_direction_smoothed_axis.normalized()
		up_direction_smoothed = VectorUtil.slerp(up_direction_smoothed, up_direction_linear, up_direction_smoothed_axis, delta * UP_DIRECTION_SMOOTH_SPEED)
	else:
		up_direction_smoothed = up_direction_linear
	
	var camera := get_viewport().get_camera_3d()
	var camera_basis := camera.global_basis
	assert(abs(camera_basis.x.length_squared() - 1.0) <= 0.01 && abs(camera_basis.y.length_squared() - 1.0) <= 0.01)
	
	var new_directional_input = Input.get_vector("left", "right", "down", "up").limit_length(1.0)
	var new_directional_length = new_directional_input.length()
	var directional_input_angle_delta = new_directional_input.angle_to(directional_input) 
	if directional_input == Vector2.ZERO || new_directional_input == Vector2.ZERO || abs(directional_input_angle_delta) > INPUT_CHANGE_ANGLE:
		directional_input = new_directional_input
	
		if directional_input == Vector2.ZERO:
			directional_input_camera = Vector3.ZERO
		else:
			directional_input_camera = directional_input.x * camera_basis.x + directional_input.y * camera_basis.y
		
		var walk_direction_into_screen := VectorUtil.make_perpendicular(-camera_basis.z, up_direction)
		var walk_direction_along_screen := VectorUtil.cross(up_direction, walk_direction_into_screen).normalized()
		#DebugDraw3D.draw_line(global_position, global_position + walk_direction_into_screen, Color.BLUE)
		#DebugDraw3D.draw_line(global_position, global_position + walk_direction_along_screen, Color.RED)
		
		var up_direction_along_screen := VectorUtil.make_perpendicular(up_direction, camera_basis.z)
		var right_direction_along_screen := VectorUtil.cross(camera_basis.z, up_direction_along_screen).normalized()
		#DebugDraw3D.draw_line(camera.global_position+ -camera_basis.z , camera.global_position + -camera_basis.z + up_direction_along_screen, Color.GREEN)
		#DebugDraw3D.draw_line(camera.global_position+ -camera_basis.z , camera.global_position + -camera_basis.z + right_direction_along_screen, Color.RED)
		
		var amount_to_walk_into_screen  := directional_input_camera.dot(up_direction_along_screen)
		var amount_to_walk_along_screen := directional_input_camera.dot(right_direction_along_screen)
		
		directional_input_player = walk_direction_into_screen * amount_to_walk_into_screen + walk_direction_along_screen * amount_to_walk_along_screen
	else:
		directional_input = new_directional_length * directional_input.normalized()
		directional_input_player = VectorUtil.make_perpendicular(directional_input_player, up_direction).normalized() * new_directional_length
		
	
	facing_direction_smoothed = VectorUtil.make_perpendicular(facing_direction_smoothed, up_direction_linear).normalized()
	global_basis = Basis(facing_direction_smoothed.cross(up_direction_linear).normalized(), up_direction_linear, -facing_direction_smoothed)

	
	state_machine.update(self, delta)
	
	if velocity.length_squared() > MAX_VELOCITY * MAX_VELOCITY:
		velocity = velocity.normalized() * MAX_VELOCITY
	move_and_slide()
	on_ground = is_on_floor()


class PlayerGroundState extends State:
	var name = "Ground"
	var extraJump: bool
	var current_walking_speed : float

	
	func on_enter(player : Node):
		player.gravity = DEFAULT_GRAVITY
		current_walking_speed = VectorUtil.get_axis(player.velocity, player.facing_direction)
	
	func check_state(player : Node) -> State:
		if !player.on_ground:
			return PlayerFallState.new()
		if Input.is_action_just_pressed("jump"):
			return PlayerJumpState.new()
		
		return null
	
	func update(player : Node, delta : float):
		var current_acceleration : float
		if player.directional_input_player:
			if player.directional_input_player.dot(player.facing_direction) < Player.WALK_SKID_ANGLE:
				player.facing_direction *= -1
				current_walking_speed *= -1
			var rotate_delta := Player.WALK_TURN_SPEED * delta
			player.facing_direction = VectorUtil.smove_toward(player.facing_direction, player.directional_input_player.normalized(), player.up_direction, rotate_delta)
			if current_walking_speed < 0:
				current_acceleration = Player.WALK_SKID_ACCELERATION
			else:
				current_acceleration = Player.WALK_ACCELERATION
		else:
			current_acceleration = Player.WALK_DECELERATION
		
		player.facing_direction_smoothed = VectorUtil.slerp(player.facing_direction_smoothed, player.facing_direction, player.up_direction, Player.WALK_TURN_SMOOTHING * delta).normalized()
		
		var target_speed : float = max(0, Player.WALK_MAX_SPEED * player.facing_direction.dot(player.directional_input_player))
		
		current_walking_speed = move_toward(current_walking_speed, target_speed, current_acceleration * delta)
		current_walking_speed = min(current_walking_speed, Player.MAX_VELOCITY)
		player.velocity = player.facing_direction * current_walking_speed - player.up_direction * 0.01
	
		
	func on_exit(_player : Node):
		pass

@abstract class PlayerAirState extends State:
	func do_air_movement(player : Node, delta : float):
		var horizontal_velocity := VectorUtil.remove_axis(player.velocity, player.up_direction)
		var target_velocity : Vector3 = player.directional_input_player * Player.WALK_MAX_SPEED
		if target_velocity.dot(player.directional_input_player) > horizontal_velocity.dot(player.directional_input_player):
			horizontal_velocity = horizontal_velocity.move_toward(target_velocity, delta * Player.AIR_ACCELERATION)
			player.velocity = VectorUtil.set_except_axis(player.velocity, horizontal_velocity, player.up_direction)
			if horizontal_velocity:
				player.facing_direction = VectorUtil.smove_toward(player.facing_direction, horizontal_velocity.normalized(), player.up_direction, Player.AIR_TURN_SPEED * delta).normalized()
		player.facing_direction_smoothed = player.facing_direction_smoothed.slerp(player.facing_direction, Player.AIR_TURN_SMOOTHING * delta).normalized()


class PlayerJumpState extends PlayerAirState:
	var name = "Jump"
	func check_state(player : Node) -> State:
		if VectorUtil.get_axis(player.velocity, player.up_direction)  < Player.APEX_START_VELOCITY:
			return PlayerApexState.new()
		elif !Input.is_action_pressed("jump"):
			return PlayerFallState.new()
		return null
	
	func on_enter(player : Node):
		player.gravity = player.JUMP_GRAVITY 
		player.velocity = VectorUtil.set_axis(player.velocity, player.up_direction * Player.JUMP_VELOCITY)
		player.on_ground = false
	
	func update(player : Node, delta : float):
		do_air_movement(player, delta)
	
	func on_exit(player : Node):
		if VectorUtil.get_axis(player.velocity, player.up_direction)  > Player.JUMP_MIN_VELOCITY:
			player.velocity = VectorUtil.set_axis(player.velocity, player.up_direction * Player.JUMP_MIN_VELOCITY)


class PlayerApexState extends PlayerAirState:
	var name = "Apex"
	var timer : float
	func check_state(player : Node) -> State:
		var y_vel : float = VectorUtil.get_axis(player.velocity, player.up_direction) 
		if timer >= Player.APEX_TIME || y_vel < Player.APEX_END_VELOCITY || !Input.is_action_pressed("jump"):
			if y_vel > Player.JUMP_MIN_VELOCITY:
				player.velocity = VectorUtil.set_axis(player.velocity, player.up_direction * Player.JUMP_MIN_VELOCITY)
			return PlayerFallState.new()
		return null
	
	func on_enter(player : Node):
		player.gravity = player.APEX_GRAVITY
	
	func update(player : Node, delta : float):
		do_air_movement(player, delta)
		timer += delta
	
	func on_exit(_player : Node):
		pass


class PlayerFallState extends PlayerAirState:
	var name = "Fall"
	func check_state(player : Node) -> State:
		if player.on_ground:
			return PlayerGroundState.new()
		return null
	
	func on_enter(player : Node):
		print("fall")
		player.gravity = player.DEFAULT_GRAVITY
	
	func update(player : Node, delta : float):
		do_air_movement(player, delta)
	
	func on_exit(_player : Node):
		pass
