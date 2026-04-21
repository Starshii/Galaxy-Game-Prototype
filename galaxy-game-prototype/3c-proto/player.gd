class_name Player extends CharacterBody3D

const MAX_VELOCITY = 80.0
const DEFAULT_GRAVITY = 40.0

const UP_DIRECTION_LINEAR_SPEED : float = deg_to_rad(360 * 2)
const UP_DIRECTIO_SMOOTH_SPEED  : float = 15

const WALK_MAX_SPEED         = 12.0
const WALK_ACCELERATION      = 30.0
const WALK_DECELERATION      = 30.0
const WALK_SKID_ACCELERATION = 60.0
const WALK_SKID_ANGLE        = -cos(deg_to_rad(45))
const WALK_TURN_SPEED        = deg_to_rad(360.0 * 2)
const WALK_TURN_SMOOTHING    = 15

const APEX_START_VELOCITY = 2.0
const APEX_END_VELOCITY   = -2.0
const APEX_TIME           = 0.1
const APEX_GRAVITY        = 20.0

const JUMP_VELOCITY = 20
const JUMP_MIN_VELOCITY = 3
const JUMP_GRAVITY = 80.0
const AIR_ACCELERATION = 30.0
const AIR_TURN_SPEED = deg_to_rad(360.0 * 1)
const AIR_TURN_SMOOTHING = 15

var current_state : PlayerState = PlayerGroundState.new()

var directional_input         : Vector2
var directional_input_length  : float
var directional_input_camera  : Vector3
var directional_input_player  : Vector3

var up_direction_linear   : Vector3
var up_direction_smoothed : Vector3

var facing_direction : Vector3
var facing_direction_smoothed : Vector3
var on_ground : bool

var gravity_areas : Array[GravityArea]
var gravity : float

func _ready() -> void:
	facing_direction = -global_basis.z
	up_direction = Vector3.UP
	up_direction_linear = up_direction
	up_direction_smoothed = up_direction_linear
	facing_direction = Vector3.FORWARD
	global_position = Vector3(0, 10, 0)
	velocity = Vector3.ZERO
	gravity = DEFAULT_GRAVITY


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
	if Input.is_action_just_pressed("nuke_player"):
		_ready()
	
	
	if len(gravity_areas) > 0:
		var gravity_area := gravity_areas[0]
		match gravity_area.type:
			GravityArea.Type.Directional:
				up_direction = -gravity_area.gravity_direction
			GravityArea.Type.ToPoint:
				up_direction = (global_position - gravity_area.to_global(gravity_area.gravity_point_center)).normalized()
			_: assert(false, "Gravity area \"%s\" is not yet implemented" % GravityArea.Type.find_key(gravity_area.type))
		facing_direction = VectorUtil.make_perpendicular(facing_direction, up_direction)
	
	var up_direction_linear_axis := up_direction_linear.cross(up_direction)
	if up_direction_linear_axis.length_squared() > 0.01:
		up_direction_linear_axis = up_direction_linear_axis.normalized()
		up_direction_linear = VectorUtil.smove_toward(up_direction_linear, up_direction, up_direction_linear_axis, delta * UP_DIRECTION_LINEAR_SPEED)
	else:
		up_direction_linear = up_direction
	
	var up_direction_smoothed_axis := up_direction_smoothed.cross(up_direction_linear)
	if up_direction_smoothed_axis.length_squared() > 0.01:
		up_direction_smoothed_axis = up_direction_smoothed_axis.normalized()
		up_direction_smoothed = VectorUtil.slerp(up_direction_smoothed, up_direction_linear, up_direction_smoothed_axis, delta * UP_DIRECTIO_SMOOTH_SPEED)
	else:
		up_direction_smoothed = up_direction_linear
	
	velocity -= up_direction * gravity * delta
	
	
	var camera_basis := get_viewport().get_camera_3d().global_basis
	assert(abs(camera_basis.x.length_squared() - 1.0) <= 0.01 && abs(camera_basis.y.length_squared() - 1.0) <= 0.01)
	
	directional_input = Input.get_vector("left", "right", "down", "up").limit_length(1.0)
	directional_input_length = directional_input.length()
	
	if directional_input == Vector2.ZERO:
		directional_input_camera = Vector3.ZERO
	else:
		directional_input_camera = directional_input.x * camera_basis.x + directional_input.y * camera_basis.y
	
	var walk_direction_into_screen := VectorUtil.make_perpendicular(-camera_basis.z, up_direction)
	var walk_direction_along_screen := VectorUtil.cross(up_direction, walk_direction_into_screen).normalized()
	var up_direction_along_screen := VectorUtil.make_perpendicular(up_direction, camera_basis.z)
	var right_direction_along_screen := VectorUtil.cross(camera_basis.z, up_direction_along_screen).normalized()
	
	var amount_to_walk_into_screen  := directional_input_camera.dot(up_direction_along_screen)
	var amount_to_walk_along_screen := directional_input_camera.dot(right_direction_along_screen)
	
	directional_input_player = walk_direction_into_screen * amount_to_walk_into_screen + walk_direction_along_screen * amount_to_walk_along_screen
	
	var checks_done : int = 0
	var states_returned : Array[String]
	while true:
		if checks_done > 10:
			assert(false, "Did 10 checks to check state. This means a cyclical loop! Here's the rundown: %s" % str(states_returned))
			break
		var new_state = current_state.check_state(self)
		checks_done += 1
		if new_state == null:
			break
		states_returned.append(new_state.name) 
		current_state.on_exit(self)
		current_state = new_state
		current_state.on_enter(self)
	
	current_state.update(self, delta)
	
	facing_direction_smoothed = VectorUtil.make_perpendicular(facing_direction_smoothed, up_direction_linear).normalized()
	global_basis = Basis(facing_direction_smoothed.cross(up_direction_linear).normalized(), up_direction_linear, -facing_direction_smoothed)
	
	if velocity.length_squared() > MAX_VELOCITY * MAX_VELOCITY:
		velocity = velocity.normalized() * MAX_VELOCITY
	move_and_slide()
	on_ground = is_on_floor()


@abstract class PlayerState:
	@abstract func on_enter(player : Player)
	@abstract func check_state(player : Player) -> PlayerState
	@abstract func update(player : Player, delta : float)
	@abstract func on_exit(player : Player)


class PlayerGroundState extends PlayerState:
	var name = "Ground"
	
	var current_walking_speed : float
	
	func on_enter(player : Player):
		player.gravity = DEFAULT_GRAVITY
		current_walking_speed = VectorUtil.get_axis(player.velocity, player.facing_direction)
	
	
	func check_state(player : Player) -> PlayerState:
		if !player.on_ground:
			return PlayerAirState.new()
		if Input.is_action_just_pressed("jump"):
			var air_state := PlayerAirState.new()
			air_state.jump(player)
			return air_state
		
		return null
	
	
	func update(player : Player, delta : float):
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
	
	
	func on_exit(_player : Player):
		pass


class PlayerAirState extends PlayerState:
	var name = "Air"
	
	
	enum SubState {
		Falling, Jumping, Apex
	}
	
	
	var state : SubState
	var apex_timer : float
	
	
	func jump(player : Player):
		player.velocity = VectorUtil.set_axis(player.velocity, player.up_direction * Player.JUMP_VELOCITY)
		player.on_ground = false
		state = SubState.Jumping
	
	
	func on_enter(_player : Player):
		pass
	
	
	func check_state(player : Player) -> PlayerState:
		if player.on_ground:
			return PlayerGroundState.new()
		
		var y_vel := VectorUtil.get_axis(player.velocity, player.up_direction)
		match state:
			SubState.Falling:
				pass
			SubState.Jumping:
				if y_vel < Player.APEX_START_VELOCITY:
					state = SubState.Apex
					apex_timer = 0
				elif !Input.is_action_pressed("jump"):
					if y_vel > Player.JUMP_MIN_VELOCITY:
						player.velocity = VectorUtil.set_axis(player.velocity, player.up_direction * Player.JUMP_MIN_VELOCITY)
					state = SubState.Falling
			SubState.Apex:
				if apex_timer >= Player.APEX_TIME || y_vel < Player.APEX_END_VELOCITY || !Input.is_action_pressed("jump"):
					if y_vel > Player.JUMP_MIN_VELOCITY:
						player.velocity = VectorUtil.set_axis(player.velocity, player.up_direction * Player.JUMP_MIN_VELOCITY)
					state = SubState.Falling
		
		return null
	
	func update(player : Player, delta : float):
		match state:
			SubState.Falling:
				player.gravity = player.DEFAULT_GRAVITY
				apex_timer = 0
			SubState.Jumping:
				player.gravity = player.JUMP_GRAVITY 
				apex_timer = 0
			SubState.Apex:
				player.gravity = player.APEX_GRAVITY
				apex_timer += delta
		
		var horizontal_velocity := VectorUtil.remove_axis(player.velocity, player.up_direction)
		var target_velocity := player.directional_input_player * Player.WALK_MAX_SPEED
		horizontal_velocity = horizontal_velocity.move_toward(target_velocity, delta * Player.AIR_ACCELERATION)
		player.velocity = VectorUtil.set_except_axis(player.velocity, horizontal_velocity, player.up_direction)
		if horizontal_velocity:
			player.facing_direction = VectorUtil.smove_toward(player.facing_direction, horizontal_velocity.normalized(), player.up_direction, Player.AIR_TURN_SPEED * delta)
		player.facing_direction_smoothed = player.facing_direction_smoothed.slerp(player.facing_direction, Player.AIR_TURN_SMOOTHING * delta).normalized()
	
	func on_exit(_player : Player):
		pass
