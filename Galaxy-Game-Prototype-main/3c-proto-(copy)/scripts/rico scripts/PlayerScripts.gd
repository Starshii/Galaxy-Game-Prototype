class_name Player extends CharacterBody3D


## ////////////////////////////////////////////////////////////////////////////////////////////////
## CHILDREN
## ////////////////////////////////////////////////////////////////////////////////////////////////

@onready var MainCam: Node3D = $CamPos

@onready var NearFloor: RayCast3D = $NearFloor
@onready var NearWall: ShapeCast3D = $NearWall
@onready var LHDis: ShapeCast3D = $LedgeHopDis

@onready var HitTimer: Timer = $HitTimer
@onready var HitBox: Area3D = $HitBox
@onready var AnimatorP: AnimationPlayer = $AnimationPlayer



## ////////////////////////////////////////////////////////////////////////////////////////////////
## VARIABLES
## ////////////////////////////////////////////////////////////////////////////////////////////////

# GENERAL /////////////////////////////////////////////////////////////////////////////////////////

# Player Health
var PlayerHealth

# SET Player UP SMOOTHLY
const UpDirLinSpd : float = TAU * 2
const UpDirLerp   : float = 15.0

var UpDirLinVec  : Vector3


# DIRECTION
var DirInput   : Vector2
var SkateInput : Vector2

var DirInputCam    : Vector3
var DirInputPlayer : Vector3

var FacingDir         : Vector3
var FacingDirSmoothed : Vector3

var DirInputLength : float


# GRAVITY
const BaseTermVel     : float = 90.0   # Max velocity the Player can move in any direction
const BaseFallTermVel : float = 30.0
const BaseGrav        : float = 40.0
const SkateGrav       : float = 60.0
const GravRampStr     : float = 0.3    # Used to make it harder for the Player to get into orbit
const OrbitalLimit    : float = 2.0

var GravStr        : float = 1.0   # Some places might have more gravity than others
var CurGrav        : float = BaseGrav
var CurFallTermVel : float = BaseFallTermVel

var GravAreaArray : Array[GravityArea]


# STATES //////////////////////////////////////////////////////////////////////////////////////////

# OTHER

var FirstFrameSkip : bool = false   # Used for certain movement to not accidentally accept double inputs

# WALK
const BaseWalkSpd   : float = 7.0
const WalkAcc       : float = 30.0
const WalkDec       : float = 30.0
const WalkSkidAcc   : float = 60.0
const WalkSkidAngle : float = -0.3
const WalkTurnSpd   : float = TAU * 1.7
const WalkTurnLerp  : float = 15.0
const BaseSkid      : float = 0.2

var SkidTimer : float
var InSkid    : bool = false

# JUMP
const BaseJumpSpd    : float = 7.0
const BaseJump       : float = 0.2
const BaseCoyote     : float = 0.2
const BaseJumpBuffer : float = 0.25

var JumpTimer      : float = BaseJump
var CoyoteTimer    : float = BaseCoyote
var JumpBufferTime : float = 0

# OTHER JUMPS
# Backflip
const BFJumpVer : float = 14.0
const BFJumpHor : float = 16.0
const BFGrav    : float = 30.0
const BFMaxGrav : float = 80.0
const BFGravMT  : float = 10.0
const BFSpdMT   : float = 8.0
const BFAcc     : float = 40.0

# Triple jump
const BaseLand  : float = 0.2
const DJJumpSpd : float = 10.0
const TJJumpVer : float = 18.0
const TJGrav    : float = 30.0
const TJAcc     : float = 10.0

var LandTime : float = 0

var ApexReached  : bool = false
var InDoubleJump : bool = false

# AIR
const BaseAirSpd  : float = 6.0
const AirAcc      : float = 30.0
const AirDec      : float = 5.0
const AirTurnSpd  : float = TAU * 1.0
const AirTurnLerp : float = 15.0

var MaxAirSpd : float

# SKATE
const BaseSkateSpd  : float = 9.0
const BaseSJumpVer  : float = 8.0
const SDJJumpVer    : float = 11.0
const STJJumpVer    : float = 18.0
const BaseSJumpHor  : float = 11.0
const SkateAcc      : float = 30.0
const SkateTurnSpd  : float = TAU * 0.7
const SkateTurnLerp : float = 15.0

var InSkate : bool = false

# SKATE DASH
const SkateDashSpd   : float = 11.0
const BaseSkateDash  : float = 0.35
const SDTurnSpd      : float = 2.0
const SDTurnLerp     : float = 30.0
const SDJumpVer      : float = 10.0
const SDJumpHor      : float = 14.0
const SDJGrav        : float = 50.0
const SDJAcc         : float = 10.0
const BaseDashBuffer : float = 0.08

var SkateDashTime  : float
var DashBufferTime : float

# SPIN
const SpinGroundHor  : float = 6.0
const SpinAirHor     : float = 10.0
const SpinAngle      : float = -0.1
const SpinGrav       : float = 30.0
const SpinJVer       : float = 17.0
const SpinAcc        : float = 20.0
const SpinDec        : float = 5.0
const Spin           : float = 0.7
const SpinAirTermVel : float = 3.5

var SpinTime : float

# FAST FALL
const FastFallTermVel : float = 30.0

# GROUND STUN
const Stun : float = 0.5

var StunTime : float

# DIVE
const BaseDiveHor    : float = 9.0
const BaseDiveVer    : float = 8.0
const DiveGrav       : float = 20.0
const DiveMaxGrav    : float = 80.0
const DiveGravMT     : float = 20.0
const DiveAcc        : float = 20.0
const DiveDec        : float = 10.0
const DiveSpdConver  : float = 0.6
const DiveBuffer     : float = 0.25
const BaseDiveAmount : int   = 1

var DiveBufferTime : float
var DiveAmount     : int
var ValidDive      : bool

#WALLCLIMB
const ClimbSpd     : float = 10.0
const WCGrav       : float = 20.0
const WallAngle    : float = 0.3
const WallStickStr : float = 3.0

#WALLSLIDE
const WSGrav       : float = 5.0
const WSTermVel    : float = 8.0

var UpdateUpDir : bool = true


#WALLJUMP
const WallVer     : float = 10.0
const WallHor     : float = 8.0
const WallBonus   : float = 3.0
const WJGrav      : float = 15.0
const WJAcc       : float = 15.0
const WJDec       : float = 10.0
const WJMaxGrav   : float = 80.0
const WJGravMT    : float = 25.0
const ValidWAngle : float = 0.6
const BaseWall    : float = 1.0

var WallTime     : float
var SavedWallVec : Vector3 = Vector3.ZERO
var SameWall     : bool    = false


#LEDGEHOP
const LHHor : float = 3.0
const LHVer : float = 10.0
const LHAcc : float = 10.0

#HIT
var GotHit : bool
var IsHit : bool
var HitPos : Vector3
var HealthAmnt : int = 3
var DmgAmnt : int
signal ChangeHealth
signal BoalbSignal
const KnockBackVecV : float = 10
const KnockBackVecH : float = 10

#BOUNCE
var CanBounce : bool
var BounceBool : bool
signal BounceSignal
var BounceVer : float
var BounceHor : float
# CAMERA VARIABLES ////////////////////////////////////////////////////////////////////////////////

const PositionStr  : float = 5.0
const CamHeight    : float = 0.0


# STATES //////////////////////////////////////////////////////////////////////////////////////////

var CurrentState : State = PlayerGroundState.new()

# PARTICLES ///////////////////////////////////////////////////////////////////////////////////////

@export var RegularJumpParticle : PackedScene 

## ////////////////////////////////////////////////////////////////////////////////////////////////
## READY
## ////////////////////////////////////////////////////////////////////////////////////////////////

func _ready() -> void:
	visible           = true
	UpDirLinVec       = up_direction
	FacingDir         = -global_basis.z
	FacingDirSmoothed = -global_basis.z
	DirInputPlayer    = -global_basis.z
	SkateInput        = Vector2.DOWN
	# Camera
	MainCam.position = position


## ////////////////////////////////////////////////////////////////////////////////////////////////
## PROCESS
## ////////////////////////////////////////////////////////////////////////////////////////////////

func _process(Delta: float) -> void:
	
	# /////////////////////////////////////////////////////////////////////////////////////////////
	# DIRECTION AND INPUT
	# /////////////////////////////////////////////////////////////////////////////////////////////
	
	# Player INPUT DIRECTION //////////////////////////////////////////////////////////////////////
	
	var CamBasis : Basis = get_viewport().get_camera_3d().global_basis
	
	# Check input
	DirInput = Input.get_vector("Left", "Right", "Down", "Up").limit_length(1.0)
	DirInputLength = DirInput.length()
	
	# Set a constant speed for the skate input state so that the Player cannot stop moving
	if DirInput:
		SkateInput = DirInput.normalized()
	
	if !InSkate:
		DirInputCam = DirInput.x * CamBasis.x + DirInput.y * CamBasis.y
	else:
		DirInputCam = SkateInput.x * CamBasis.x + SkateInput.y * CamBasis.y
	
	# Get necessary input directions for movement
	var TruePlayerZ := VectorUtil.make_perpendicular(-CamBasis.z, up_direction) # X axis for the Player using cam basis
	var TruePlayerX := VectorUtil.cross(up_direction, TruePlayerZ).normalized() # Z axis for the Player using cam basis
	
	var VisualY := VectorUtil.make_perpendicular(up_direction, CamBasis.z) # Screen Y axis
	var VisualX := VectorUtil.cross(CamBasis.z, VisualY).normalized()      # Screen X axis
	
	var DisZ  := DirInputCam.dot(VisualY)
	var DisX := DirInputCam.dot(VisualX)
	
	DirInputPlayer = TruePlayerX * DisX + TruePlayerZ * DisZ
	
	
	# UP DIRECTION LINEAR /////////////////////////////////////////////////////////////////////////
	
	# Used for smooth changes to Player's basis
	var UpDirLinAxis := UpDirLinVec.cross(up_direction)
	if UpDirLinAxis.length_squared() > 0.01:
		UpDirLinAxis = UpDirLinAxis.normalized()
		UpDirLinVec = VectorUtil.smove_toward(UpDirLinVec, up_direction, UpDirLinAxis, Delta * UpDirLinSpd)
	else:
		UpDirLinVec = up_direction
	
	
	# TRUE FACING DIRECTION ///////////////////////////////////////////////////////////////////////
	
	FacingDirSmoothed = VectorUtil.make_perpendicular(FacingDirSmoothed, UpDirLinVec).normalized()
	if FacingDirSmoothed.cross(UpDirLinVec) != Vector3.ZERO:
		global_basis = Basis.looking_at(FacingDirSmoothed, UpDirLinVec)
	
	
	# CAMERA POSITION /////////////////////////////////////////////////////////////////////////////
	
	# Lerp position
	var UpLength : Vector3 = CamHeight * up_direction
	var TargetC  : Basis   = Basis.IDENTITY
	
	TargetC = Basis.looking_at(VectorUtil.make_perpendicular(-MainCam.global_basis.z, up_direction), up_direction)
	MainCam.global_position = lerp(MainCam.global_position, global_position + UpLength, min(1.0, PositionStr * Delta))
	MainCam.global_basis = MainCam.global_basis.slerp(TargetC, 3 * Delta).orthonormalized()
	
	
	# /////////////////////////////////////////////////////////////////////////////////////////////
	# GRAVITY AREA SORTING AND UP-DIRECTION
	# /////////////////////////////////////////////////////////////////////////////////////////////
	
	# GRAVITY AREAS ///////////////////////////////////////////////////////////////////////////////
	
	if len(GravAreaArray) > 0 and UpdateUpDir:
		
		# Get the first gravity area and check its type
		var GravArea := GravAreaArray[0]
		match GravArea.GravityType:
			GravityArea.Type.Directional:
				up_direction = -GravArea.gravity_direction
			GravityArea.Type.ToPoint:
				up_direction = (global_position - GravArea.global_position).normalized()
			GravityArea.Type.FromPoint:
				up_direction = -(global_position - GravArea.global_position).normalized()
			GravityArea.Type.ToLine: 
				var LineVectorGlobal := GravArea.global_basis * GravArea.gravity_point_center
				var GravityMiddle := VectorUtil.project_on_line(GravArea.global_position, LineVectorGlobal, global_position)
				up_direction = -(GravityMiddle - global_position).normalized()
			GravityArea.Type.FromLine: 
				var LineVectorGlobal := GravArea.global_basis * GravArea.gravity_point_center
				var GravityMiddle := VectorUtil.project_on_line(GravArea.global_position, LineVectorGlobal, global_position)
				up_direction = (GravityMiddle - global_position).normalized()
		
		# Set the facing direction of the Player correctly with the new gravity field
		FacingDir = VectorUtil.make_perpendicular(FacingDir, up_direction)
	
	
	# GRAVITY AND TERMINAL VELOCITY ///////////////////////////////////////////////////////////////
	
	# Certain planets might have a stronger gravity, GravStr is used in that case
	velocity -= up_direction * CurGrav * GravStr * Delta
	
	# The Player can only move at a certain speed towards the ground
	if VectorUtil.get_axis(velocity, -up_direction) > CurFallTermVel:
		var VelHor : float = VectorUtil.get_axis(velocity, FacingDir)
		velocity = VelHor * FacingDir + CurFallTermVel * -up_direction
	
	# The Player can't exceed terminal velocity
	if velocity.length() > BaseTermVel:
		velocity = velocity.normalized() * BaseTermVel
	
	
	# /////////////////////////////////////////////////////////////////////////////////////////////
	# STATE-MACHINE
	# /////////////////////////////////////////////////////////////////////////////////////////////
	
	# Get the new state
	var NewState: State = CurrentState.check_state(self)
	if NewState != null:
		CurrentState.on_exit(self)
		CurrentState = NewState
		CurrentState.on_enter(self)
		FirstFrameSkip = true
		
		print(CurrentState.Name)
	
	# Update the state
	CurrentState.update(self, Delta)
	
	
	# /////////////////////////////////////////////////////////////////////////////////////////////
	# NEAR FLOOR CHECK
	# /////////////////////////////////////////////////////////////////////////////////////////////
	
	if NearFloor.is_colliding() and DiveBufferTime <= 0:
		ValidDive = false
	else:
		ValidDive = true
	
	if velocity.dot(up_direction) > 0:
		NearFloor.enabled = false
		ValidDive         = true
	else:
		NearFloor.enabled = true
	
	
	# /////////////////////////////////////////////////////////////////////////////////////////////
	# MOVE AND SLIDE
	# /////////////////////////////////////////////////////////////////////////////////////////////
	
	move_and_slide()


## ////////////////////////////////////////////////////////////////////////////////////////////////
## STATES
## ////////////////////////////////////////////////////////////////////////////////////////////////

# ////////////////////////////////////////////////////////////////////////////////////////////////
# GROUND STATE
# ////////////////////////////////////////////////////////////////////////////////////////////////

class PlayerGroundState extends State:
	var Name = "Ground"
	
	var CurWalkSpd : float = 0
	
	func on_enter(This : Player):
		This.CoyoteTimer  = BaseCoyote
		This.DiveAmount   = BaseDiveAmount
		This.SavedWallVec = Vector3.ZERO
		
		This.FacingDir         = VectorUtil.make_perpendicular(This.FacingDir, This.up_direction)
		This.FacingDirSmoothed = VectorUtil.make_perpendicular(This.FacingDirSmoothed, This.up_direction)
		
		if This.InSkate and This.velocity.length() < BaseSkateSpd:
			This.velocity = This.velocity.normalized() * BaseSkateSpd
			CurWalkSpd    = VectorUtil.get_axis(This.velocity, This.FacingDir)
		else:
			CurWalkSpd = VectorUtil.get_axis(This.velocity, This.FacingDir)
		
		This.velocity = VectorUtil.remove_axis(This.velocity, This.up_direction)
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: 
			return HitState.new() 
		if This.CanBounce: 
			return BounceState.new()
		
		# Air state
		if This.CoyoteTimer <= 0:
			return PlayerAirState.new()
		
		# Jump state
		if Input.is_action_just_pressed("Jump") or This.JumpBufferTime > 0:
			
			# Check the type of jump the Player performs
			if This.InSkid:
				return PlayerBackFlipState.new()
			elif This.LandTime > 0 and This.InDoubleJump and This.ApexReached:
				return PlayerTripleJumpState.new()
			elif This.LandTime > 0:
				This.InDoubleJump = true
				return PlayerJumpState.new()
			else:
				return PlayerJumpState.new()
		
		# SkateDash State
		if Input.is_action_just_pressed("Skate") or This.DashBufferTime > 0:
			return PlayerSkateDashState.new()
		
		# Spin State
		if This.InSkate and This.DirInputPlayer.dot(This.FacingDir) < This.SpinAngle:
			return PlayerSpinGroundState.new()
		
		return null
	
	
	func update(This : Player, Delta : float):
		
		# Exit skate mode
		if !Input.is_action_pressed("Skate"):
			This.InSkate = false
		
		# Start coyote time when not on floor
		if This.is_on_floor():
			This.CoyoteTimer = BaseCoyote
		else:
			This.CoyoteTimer -= Delta
		
		
		if !This.InSkate:
			CurWalkSpd = This.GroundMovement(This, CurWalkSpd, Delta)
			
			# Skid when turning too sharply
			if This.DirInputPlayer.dot(This.FacingDir) < This.WalkSkidAngle:
				This.FacingDir *= -1
				CurWalkSpd     *= -1
				This.InSkid     = true
				This.SkidTimer  = BaseSkid
			
			# End skid (Time window for the backflip action)
			if This.InSkid:
				This.SkidTimer -= Delta
			if This.SkidTimer <= 0:
				This.InSkid = false
		
		else:
			CurWalkSpd = This.SkateGroundMovement(CurWalkSpd, Delta)
		
		# Count down the timer to check if the Player can double-jump
		This.LandTime -= Delta
		
		# End the double jump if the timer has run out
		if This.LandTime <= 0:
			This.InDoubleJump = false
			This.ApexReached  = false
	
	
	func on_exit(This : Player):
		This.InSkid         = false
		This.DashBufferTime = 0
		This.JumpBufferTime = 0


# ////////////////////////////////////////////////////////////////////////////////////////////////
# AIR STATE
# ////////////////////////////////////////////////////////////////////////////////////////////////

class PlayerAirState extends State:
	var Name = "Air"
	
	var InJumpBuffer : bool  = false
	var EnteredUpSpd : float
	
	
	func on_enter(This : Player):
		This.MaxAirSpd = maxf(VectorUtil.get_axis(This.velocity, This.DirInputPlayer), BaseAirSpd)
		EnteredUpSpd   = maxf(1.0, VectorUtil.get_axis(This.velocity, This.up_direction))
		
		This.DiveBufferTime = DiveBuffer
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Ground state
		if This.is_on_floor():
			return PlayerGroundState.new()
		
		# Fastfall state
		if Input.is_action_just_pressed("Skate"):
			This.DashBufferTime = BaseDashBuffer
			return PlayerFastFallState.new()
		
		# Dive state
		if Input.is_action_just_pressed("Jump") and This.ValidDive and This.DiveAmount > 0:
			return PlayerDiveState.new()
		
		#Wall climb state
		if This.is_on_wall_only() and VectorUtil.\
		make_perpendicular(This.get_wall_normal(), This.up_direction).dot(-This.DirInputPlayer) > WallAngle:
			if This.velocity.dot(This.up_direction) < 0:
				if This.get_wall_normal().dot(This.SavedWallVec) > ValidWAngle:
					This.SameWall = true
					return PlayerWallSlideState.new()
				return PlayerWallClimbState.new()
		return null
	
	
	func update(This : Player, Delta : float):
		
		# Exit skate mode
		if !Input.is_action_pressed("Skate"):
			This.InSkate = false
		
		This.AirMovement(AirAcc, AirDec, Delta)
		
		# Activate Jump buffer
		if Input.is_action_just_pressed("Jump"):
			InJumpBuffer        = true
			This.JumpBufferTime = BaseJumpBuffer
		if InJumpBuffer:
			This.JumpBufferTime -= Delta
		
		# Limit insane upwards momentum
		if VectorUtil.get_axis(This.velocity, This.up_direction) > EnteredUpSpd:
			This.velocity = VectorUtil.set_axis(This.velocity, EnteredUpSpd * This.up_direction)
		
		# The time in which the floor raycast is ignored to make diving inputs not feel eaten
		This.DiveBufferTime -= Delta
	
	
	func on_exit(This : Player):
		This.DiveBufferTime = 0


# ////////////////////////////////////////////////////////////////////////////////////////////////
# JUMP STATE
# ////////////////////////////////////////////////////////////////////////////////////////////////

class PlayerJumpState extends State:
	var Name = "Jump"
	
	var JumpHeight : float
	
	
	func on_enter(This : Player):
		#particle animation
		var regularjumpparticle : Node3D = This.RegularJumpParticle.instantiate()
		This.add_child(regularjumpparticle)
		
		This.MaxAirSpd      = maxf(VectorUtil.get_axis(This.velocity, This.DirInputPlayer), BaseAirSpd)
		This.CurGrav        = 0
		This.JumpTimer      = BaseJump
		
		# Check jump height depending on if the Player is skating and/or double jumping
		if This.InDoubleJump and This.InSkate:
			if This.MaxAirSpd < BaseSJumpHor:
				This.MaxAirSpd = BaseSJumpHor
			This.velocity  = BaseSJumpHor * -This.basis.z
			JumpHeight     = SDJJumpVer
		elif This.InSkate:
			if This.MaxAirSpd < BaseSJumpHor:
				This.MaxAirSpd = BaseSJumpHor
			This.velocity  = This.MaxAirSpd * -This.basis.z
			JumpHeight     = BaseSJumpVer
		
		elif This.InDoubleJump:
			JumpHeight = DJJumpSpd
		else:
			JumpHeight = BaseJumpSpd
		
		This.velocity += JumpHeight * This.up_direction
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Air state
		if This.JumpTimer <= 0:
			This.ApexReached = true
			return PlayerAirState.new()
		if !Input.is_action_pressed("Jump"):
			return PlayerAirState.new()
		
		# Fastfall state
		if Input.is_action_just_pressed("Skate"):
			return PlayerFastFallState.new()
		
		return null
	
	
	func update(This : Player, Delta : float):
		This.JumpTimer -= Delta
		This.AirMovement(AirAcc, AirDec, Delta)
		
		var HorSpd : float = VectorUtil.get_axis(This.velocity, This.FacingDir)
		var VerSpd : float = VectorUtil.get_axis(This.velocity, This.up_direction)
		
		if VerSpd > JumpHeight:
			This.velocity  = HorSpd * This.FacingDir
			This.velocity += JumpHeight * This.up_direction
	
	
	func on_exit(This : Player):
		This.CurGrav  = BaseGrav
		This.LandTime = BaseLand


# ////////////////////////////////////////////////////////////////////////////////////////////////
# SKATEDASH STATE
# ////////////////////////////////////////////////////////////////////////////////////////////////

class PlayerSkateDashState extends State:
	var Name = "SkateDash"
	
	
	func on_enter(This : Player):
		This.SkateDashTime     = BaseSkateDash
		
		if This.DirInputPlayer: 
			This.FacingDir = This.DirInputPlayer
		This.FacingDirSmoothed = This.FacingDir
		This.velocity          = SkateDashSpd * This.FacingDir
		This.InDoubleJump      = false
		This.ApexReached       = false
		This.LandTime          = 0
		This.InSkate           = true
		
		This.FOVEffect()
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Ground state
		if This.is_on_floor() and This.SkateDashTime <= 0:
			return PlayerGroundState.new()
		if This.is_on_floor() and Input.is_action_just_pressed("Skate"):
			This.DashBufferTime = BaseDashBuffer
			return PlayerGroundState.new()
		
		# Air state
		if This.CoyoteTimer <= 0:
			return PlayerAirState.new()
		if !This.is_on_floor() and This.SkateDashTime <= 0:
			return PlayerAirState.new()
		
		# DashJump state
		if Input.is_action_just_pressed("Jump"):
			return PlayerDashJumpState.new()
		
		# Spin State
		if This.InSkate and This.DirInputPlayer.dot(This.FacingDir) < This.SpinAngle:
			return PlayerSpinGroundState.new()
		
		return null
	
	
	func update(This : Player, Delta : float):
		
		# Exit skate mode
		if !Input.is_action_pressed("Skate"):
			This.InSkate = false
		
		# Turn the Player slowly towards the direction the Player presses
		if This.DirInputPlayer:
			This.FacingDir = VectorUtil.\
			smove_toward(This.FacingDir, This.DirInputPlayer.normalized(), This.up_direction, SDTurnSpd * Delta)
		
		# Smooth the direction the Player is facing in
		This.FacingDirSmoothed = VectorUtil.\
		slerp(This.FacingDirSmoothed, This.FacingDir, This.up_direction, SDTurnLerp * Delta).normalized()
		
		This.velocity = VectorUtil.set_except_axis(This.velocity, This.FacingDir * SkateDashSpd, This.up_direction)
		
		# Start coyote time when not on floor
		if This.is_on_floor():
			This.CoyoteTimer = BaseCoyote
		else:
			This.CoyoteTimer -= Delta
		
		# Count down the dash timer
		This.SkateDashTime -= Delta
	
	
	func on_exit(This : Player):
		This.SkateDashTime = 0

class PlayerDashJumpState extends State:
	var Name = "DashJump"
	
	var CurWalkSpd   : float
	var InJumpBuffer : bool = false
	
	
	func on_enter(This : Player):
		This.velocity  = SDJumpHor * This.FacingDir 
		This.velocity += SDJumpVer * This.up_direction
		This.CurGrav   = SDJGrav
		This.MaxAirSpd = SDJumpHor
		
		This.FOVEffect(12.0)
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Ground state
		if This.is_on_floor():
			return PlayerGroundState.new()
		
		# Air state
		if !Input.is_action_pressed("Skate"):
			This.InSkate = false
			return PlayerAirState.new()
			
		#Wall climb state
		if This.is_on_wall_only() and VectorUtil.\
		make_perpendicular(This.get_wall_normal(), This.up_direction).dot(-This.DirInputPlayer) > WallAngle:
				if This.get_wall_normal().dot(This.SavedWallVec) > ValidWAngle:
					This.SameWall = true
					return PlayerWallSlideState.new()
				return PlayerWallClimbState.new()
		return null
	
	
	func update(This : Player, Delta : float):
		This.AirMovement(SDJAcc, AirDec, Delta)
		
		# Activate Jump buffer (SKIP FIRST FRAME BECAUSE JUMP WAS JUST PRESSED)
		if Input.is_action_just_pressed("Jump") and !This.FirstFrameSkip:
			InJumpBuffer        = true
			This.JumpBufferTime = BaseJumpBuffer
		if InJumpBuffer:
			This.JumpBufferTime -= Delta
		
		This.FirstFrameSkip = false
	
	
	func on_exit(This : Player):
		This.CurGrav   = BaseGrav
		This.LandTime  = BaseLand
		This.MaxAirSpd = SkateDashSpd


# ////////////////////////////////////////////////////////////////////////////////////////////////
# OTHER JUMP STATES
# ////////////////////////////////////////////////////////////////////////////////////////////////

class PlayerBackFlipState extends State:
	var Name = "BackFlip"
	
	var CurWalkSpd : float
	var EnteredDir : Vector2
	
	func on_enter(This : Player):
		This.MaxAirSpd          = maxf(VectorUtil.get_axis(This.velocity, This.DirInputPlayer), BaseAirSpd)
		This.velocity          += BFJumpVer * This.up_direction
		This.FacingDirSmoothed  = This.FacingDir
		This.CurGrav            = BFGrav
		EnteredDir              = This.DirInput
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Ground state
		if This.is_on_floor():
			return PlayerGroundState.new()
		
		# Air state
		if Input.is_action_just_released("Jump"):
			return PlayerAirState.new()
		if EnteredDir.dot(This.DirInput) < 0.7:
			return PlayerAirState.new()
		
		# Fastfall state
		if Input.is_action_just_pressed("Skate"):
			return PlayerFastFallState.new()
		
		# Dive state
		if Input.is_action_just_pressed("Jump") and This.ValidDive and This.DiveAmount > 0:
			return PlayerDiveState.new()
			
		#Wall climb state
		if This.is_on_wall_only() and VectorUtil.\
		make_perpendicular(This.get_wall_normal(), This.up_direction).dot(-This.DirInputPlayer) > WallAngle:
			if This.velocity.dot(This.up_direction) < 0:
				if This.get_wall_normal().dot(This.SavedWallVec) > ValidWAngle:
					This.SameWall = true
					return PlayerWallSlideState.new()
				return PlayerWallClimbState.new()
		return null
	
	
	func update(This : Player, Delta : float):
		This.AirMovement(BFAcc, AirDec, Delta)
		
		# Slowly increase the backflip gravity and speed
		This.CurGrav   = move_toward(This.CurGrav, BFMaxGrav, BFGravMT * Delta)
		This.MaxAirSpd = move_toward(This.MaxAirSpd, BFJumpHor, BFSpdMT * Delta)
	
	
	func on_exit(This : Player):
		This.CurGrav = BaseGrav

class PlayerTripleJumpState extends State:
	var Name = "TripleJump"
	
	var CurWalkSpd : float
	
	func on_enter(This : Player):
		This.velocity    += TJJumpVer * This.up_direction
		This.CurGrav      = TJGrav
		This.InDoubleJump = false
		This.ApexReached  = false
		This.LandTime     = 0
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Air state
		if This.velocity.normalized().dot(This.up_direction) < 0.0:
			return PlayerAirState.new()
		
		# Fastfall state
		if Input.is_action_just_pressed("Skate"):
			return PlayerFastFallState.new()
		
		# Dive state
		if Input.is_action_just_pressed("Jump") and This.ValidDive and This.DiveAmount > 0:
			return PlayerDiveState.new()
		
		return null
	
	
	func update(This : Player, Delta : float):
		This.AirMovement(TJAcc, AirDec, Delta)
	
	
	func on_exit(This : Player):
		This.CurGrav        = BaseGrav
		This.JumpBufferTime = 0


# ////////////////////////////////////////////////////////////////////////////////////////////////
# SPIN STATES
# ////////////////////////////////////////////////////////////////////////////////////////////////

class PlayerSpinGroundState extends State:
	var Name = "SpinGround"
	
	
	func on_enter(This : Player):
		This.CoyoteTimer = BaseCoyote
		This.SpinTime    = Spin
		This.InDoubleJump = false
		This.ApexReached  = false
		This.LandTime     = 0
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Ground state
		if !Input.is_action_pressed("Skate"):
			This.InSkate = false
			return PlayerGroundState.new()
		if This.SpinTime <= 0:
			return PlayerGroundState.new()
		
		# Air state
		if This.CoyoteTimer <= 0:
			return PlayerSpinAirState.new()
		
		# Spin jump state
		if Input.is_action_just_pressed("Jump"):
			return PlayerSpinJumpState.new()
		
		return null
	
	
	func update(This : Player, Delta : float):
		
		# Exit Spin mode on a timer
		This.SpinTime -= Delta
		
		# Start coyote time when not on floor
		if This.is_on_floor():
			This.CoyoteTimer = BaseCoyote
		else:
			This.CoyoteTimer -= Delta
		
		This.SpinMovement(SpinGroundHor, Delta)
	
	
	func on_exit(_This : Player):
		pass

class PlayerSpinJumpState extends State:
	var Name = "SpinJump"
	
	
	func on_enter(This : Player):
		This.velocity += SpinJVer * This.up_direction
		This.CurGrav   = SpinGrav
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Spin air state
		if This.velocity.normalized().dot(This.up_direction) < 0.0:
			return PlayerSpinAirState.new()
		
		# Fastfall state
		if Input.is_action_just_pressed("Skate"):
			return PlayerFastFallState.new()
		
		# Dive state
		if Input.is_action_just_pressed("Jump") and This.ValidDive and This.DiveAmount > 0:
			return PlayerDiveState.new()
		
		return null
	
	
	func update(This : Player, Delta : float):
		This.SpinMovement(SpinAirHor, Delta)
	
	
	func on_exit(This : Player):
		This.CurGrav = BaseGrav

class PlayerSpinAirState extends State:
	var Name = "SpinAir"
	
	var InJumpBuffer : bool = false
	
	func on_enter(This : Player):
		This.SpinTime       = Spin
		This.CurFallTermVel = SpinAirTermVel
		This.CurGrav        = SpinGrav
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Ground state
		if This.is_on_floor():
			return PlayerGroundState.new()
		
		# Air state
		if !Input.is_action_pressed("Skate"):
			This.InSkate = false
			return PlayerAirState.new()
		
		# Dive state
		if Input.is_action_just_pressed("Jump") and This.ValidDive and This.DiveAmount > 0:
			return PlayerDiveState.new()
		
			#Wall climb state
		if This.is_on_wall_only() and VectorUtil.\
		make_perpendicular(This.get_wall_normal(), This.up_direction).dot(-This.DirInputPlayer) > WallAngle:
			if This.velocity.dot(This.up_direction) < 0:
				if This.get_wall_normal().dot(This.SavedWallVec) > ValidWAngle:
					This.SameWall = true
					return PlayerWallSlideState.new()
				return PlayerWallClimbState.new()
		return null
	
	
	func update(This : Player, Delta : float):
		
		This.SpinMovement(SpinAirHor, Delta)
	
	
	func on_exit(This : Player):
		This.CurGrav        = BaseGrav 
		This.CurFallTermVel = BaseFallTermVel


# ////////////////////////////////////////////////////////////////////////////////////////////////
# FASTFALL STATE
# ////////////////////////////////////////////////////////////////////////////////////////////////

class PlayerFastFallState extends State:
	var Name = "FastFall"
	
	var InJumpBuffer : bool = false
	var InDashBuffer : bool = false
	
	
	func on_enter(This : Player):
		This.CurFallTermVel = FastFallTermVel
		This.velocity = VectorUtil.set_except_axis(This.velocity, FastFallTermVel * -This.up_direction, This.FacingDir)
		
		if This.DashBufferTime > 0:
			InDashBuffer = true
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Ground stun state
		if This.is_on_floor():
			return PlayerGroundStunState.new()
		
		# Dive state
		if Input.is_action_just_pressed("Jump") and This.ValidDive and This.DiveAmount > 0:
			return PlayerDiveState.new()
		
		return null
	
	
	func update(This : Player, Delta : float):
		
		# Activate Jump buffer
		if Input.is_action_just_pressed("Jump"):
			InJumpBuffer        = true
			This.JumpBufferTime = BaseJumpBuffer
		if InJumpBuffer:
			This.JumpBufferTime -= Delta
		
		# Activate Dash buffer
		if Input.is_action_just_pressed("Skate"):
			InDashBuffer        = true
			This.DashBufferTime = BaseDashBuffer
		if InDashBuffer:
			This.DashBufferTime -= Delta
		
		This.SpinMovement(SpinGroundHor, Delta)
	
	
	func on_exit(This : Player):
		This.CurFallTermVel = BaseFallTermVel

class PlayerGroundStunState extends State:
	var Name = "GroundStun"
	
	
	func on_enter(This : Player):
		This.velocity   = Vector3.ZERO
		This.StunTime   = Stun
		This.DiveAmount = BaseDiveAmount
		
		This.SavedWallVec = Vector3.ZERO
		This.ThumpCamEffect()
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Ground state
		if This.StunTime <= 0:
			return PlayerGroundState.new()
		
		# Spin jump state
		if Input.is_action_just_pressed("Jump") or This.JumpBufferTime > 0:
			return PlayerSpinJumpState.new()
		
		# SkateDash State
		if Input.is_action_just_pressed("Skate") or (This.DashBufferTime > 0 and This.DirInputPlayer):
			return PlayerSkateDashState.new()
		
		return null
	
	
	func update(This : Player, Delta : float):
		This.StunTime -= Delta
	
	
	func on_exit(This : Player):
		This.JumpBufferTime = 0
		This.DashBufferTime = 0


# ////////////////////////////////////////////////////////////////////////////////////////////////
# SPIN STATES
# ////////////////////////////////////////////////////////////////////////////////////////////////

class PlayerDiveState extends State:
	var Name = "Dive"
	
	var InJumpBuffer : bool = false
	var EnteredUpSpd : float
	
	
	func on_enter(This : Player):
		if This.DirInputPlayer: 
			This.FacingDir = This.DirInputPlayer
		This.FacingDirSmoothed = This.FacingDir
		
		var EnteredHor : float = VectorUtil.get_axis(This.velocity, This.FacingDir)
		var EnteredVer : float = VectorUtil.get_axis(This.velocity, This.up_direction)
		var HorBonus   : float = abs(EnteredVer) * DiveSpdConver
		if EnteredHor > HorBonus:
			HorBonus = EnteredHor
		
		if HorBonus < BaseDiveHor:
			This.velocity = BaseDiveHor * This.FacingDir 
		else:
			This.velocity = HorBonus * This.FacingDir 
			This.FOVEffect(HorBonus)
		This.velocity += maxf(0, BaseDiveVer + minf(0, EnteredVer)) * This.up_direction 
		
		This.MaxAirSpd      = BaseDiveHor
		This.CurGrav        = DiveGrav 
		This.JumpBufferTime = 0
		This.InDoubleJump   = false
		This.ApexReached    = false
		This.LandTime       = 0
		This.DiveAmount    -= 1
		EnteredUpSpd        = BaseDiveVer
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Ground state
		if This.is_on_floor():
			return PlayerGroundState.new()
		
		# Fastfall state
		if Input.is_action_just_pressed("Skate"):
			This.DashBufferTime = BaseDashBuffer
			return PlayerFastFallState.new()
		
			
		#Wall climb state
		if This.is_on_wall_only() and VectorUtil.\
		make_perpendicular(This.get_wall_normal(), This.up_direction).dot(-This.DirInputPlayer) > WallAngle:
				if This.get_wall_normal().dot(This.SavedWallVec) > ValidWAngle:
					This.SameWall = true
					return PlayerWallSlideState.new()
				return PlayerWallClimbState.new()
		return null
	
	
	func update(This : Player, Delta : float):
		This.AirMovement(DiveAcc, DiveDec, Delta)
		
		# Activate Jump buffer
		if Input.is_action_just_pressed("Jump"):
			InJumpBuffer        = true
			This.JumpBufferTime = BaseJumpBuffer
		if InJumpBuffer:
			This.JumpBufferTime -= Delta
		
		# Gradually increase the fall-speed of the dive
		This.CurGrav = move_toward(This.CurGrav, DiveMaxGrav, DiveGravMT * Delta)
		
		# Limit insane upwards momentum
		if VectorUtil.get_axis(This.velocity, This.up_direction) > EnteredUpSpd:
			This.velocity = VectorUtil.set_axis(This.velocity, EnteredUpSpd * This.up_direction)
	
	
	func on_exit(This : Player):
		This.DashBufferTime = 0
		This.CurGrav        = BaseGrav


# ////////////////////////////////////////////////////////////////////////////////////////////////
# WALLSLIDE STATE
# ////////////////////////////////////////////////////////////////////////////////////////////////

class PlayerWallClimbState extends State:
	var Name = "WallClimb"
	
	var OnWall : bool = true
	
	
	func on_enter(This : Player):
		This.CurGrav        = WCGrav
		This.DiveAmount     = BaseDiveAmount
		This.UpdateUpDir    = false
		This.SavedWallVec   = This.get_wall_normal()
		
		This.up_direction      = VectorUtil.make_perpendicular(This.up_direction, This.get_wall_normal())
		This.FacingDir         = -This.get_wall_normal()
		This.FacingDirSmoothed = This.FacingDir
		This.velocity          = This.up_direction * ClimbSpd
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Wall slide state
		if This.velocity.normalized().dot(This.up_direction) < 0.0:
			return PlayerWallSlideState.new()
		
		# Wall jump state
		if Input.is_action_just_pressed("Jump") or This.JumpBufferTime > 0.0:
			return PlayerWallJumpState.new()
		
		# Ledge hop state
		if !This.LHDis.is_colliding() and !This.FirstFrameSkip:
			return PlayerLedgeHopState.new()
		This.FirstFrameSkip = false
		
		# Air state
		if !OnWall:
			return PlayerAirState.new()
		
		return null
	
	
	func update(This : Player, Delta : float):
		
		This.velocity += This.FacingDir * WallStickStr * Delta
		
		# Stick the player to a nearby wall
		if !This.NearWall.is_colliding():
			OnWall = false
		
		if OnWall:
			var WallNormal : Vector3 = This.NearWall.get_collision_normal(0)
			This.up_direction      = VectorUtil.make_perpendicular(This.up_direction, WallNormal)
			This.FacingDir         = -WallNormal
			This.FixFacingDir()
			This.FacingDirSmoothed = This.FacingDirSmoothed.slerp(This.FacingDir, AirTurnLerp * Delta).normalized()
	
	
	func on_exit(This : Player):
		This.CurGrav        = BaseGrav
		This.CurFallTermVel = BaseFallTermVel
		This.UpdateUpDir    = true
		This.JumpBufferTime = 0

class PlayerWallSlideState extends State:
	var Name = "WallSlide"
	
	var OnWall : bool = true
	
	
	func on_enter(This : Player):
		This.CurGrav        = WSGrav
		This.CurFallTermVel = WSTermVel
		This.DiveAmount     = BaseDiveAmount
		This.velocity       = Vector3.ZERO
		This.UpdateUpDir    = false
		This.SavedWallVec   = This.get_wall_normal()
		
		This.up_direction      = VectorUtil.make_perpendicular(This.up_direction, This.get_wall_normal())
		This.FacingDir         = -This.get_wall_normal()
		This.FacingDirSmoothed = This.FacingDir
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Ground state
		if This.is_on_floor():
			return PlayerGroundState.new()
		
		# Weak Wall jump state
		if Input.is_action_just_pressed("Jump") and This.SameWall:
			return PlayerWallJumpWeakState.new()
		
		# Wall jump state
		if Input.is_action_just_pressed("Jump"):
			return PlayerWallJumpState.new()
		
		# Ledge hop state
		if !This.LHDis.is_colliding() and !This.FirstFrameSkip:
			return PlayerLedgeHopState.new()
		This.FirstFrameSkip = false
		
		# Ledge hop state
		if !This.LHDis.is_colliding() and !This.FirstFrameSkip:
			return PlayerLedgeHopState.new()
		This.FirstFrameSkip = false
		
		# Air state
		if !OnWall:
			return PlayerAirState.new()
	
		return null
	
	
	func update(This : Player, Delta : float):
		
		This.velocity += This.FacingDir * WallStickStr * Delta
		
		# Stick the player to a nearby wall
		if !This.NearWall.is_colliding():
			OnWall = false
		
		if OnWall:
			var WallNormal : Vector3 = This.NearWall.get_collision_normal(0)
			This.up_direction      = VectorUtil.make_perpendicular(This.up_direction, WallNormal)
			This.FacingDir         = -WallNormal
			This.FixFacingDir()
			This.FacingDirSmoothed = This.FacingDirSmoothed.slerp(This.FacingDir, AirTurnLerp * Delta).normalized()
	
	
	func on_exit(This : Player):
		This.CurGrav        = BaseGrav
		This.CurFallTermVel = BaseFallTermVel
		This.UpdateUpDir    = true
		This.JumpBufferTime = 0
		This.SameWall       = false


# ////////////////////////////////////////////////////////////////////////////////////////////////
# WALLJUMP STATE
# ////////////////////////////////////////////////////////////////////////////////////////////////

class PlayerWallJumpState extends State:
	var Name = "WallJump"
	
	var InJumpBuffer : bool  = false
	var EnteredUpSpd : float
	
	
	func on_enter(This : Player):
		This.MaxAirSpd      = WallHor
		This.CurGrav        = WJGrav
		This.WallTime       = BaseWall
		This.JumpBufferTime = 0
		
		This.FacingDir        *= -1
		This.FacingDirSmoothed = This.FacingDir
		
		if VectorUtil.get_axis(This.velocity, This.up_direction) < WallVer + WallBonus:
			EnteredUpSpd   = WallVer
			This.velocity += This.up_direction * (WallVer + WallBonus)
		else:
			EnteredUpSpd   = VectorUtil.get_axis(This.velocity, This.up_direction) + WallBonus
			This.velocity += This.up_direction * (VectorUtil.get_axis(This.velocity, This.up_direction) + WallBonus)
		
		This.velocity += This.FacingDir * WallHor
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Ground state
		if This.is_on_floor():
			return PlayerGroundState.new()
		
		# Fastfall state
		if Input.is_action_just_pressed("Skate"):
			This.DashBufferTime = BaseDashBuffer
			return PlayerFastFallState.new()
		
		# Dive state
		if Input.is_action_just_pressed("Jump") and This.ValidDive and This.DiveAmount > 0:
			return PlayerDiveState.new()
		
		# Wall climb state
		if This.is_on_wall_only() and VectorUtil.\
		make_perpendicular(This.get_wall_normal(), This.up_direction).dot(-This.DirInputPlayer) > WallAngle:
			if This.velocity.dot(This.up_direction) < 0:
				if This.get_wall_normal().dot(This.SavedWallVec) > ValidWAngle:
					This.SameWall = true
					return PlayerWallSlideState.new()
				return PlayerWallClimbState.new()
		
		# Air state
		if This.WallTime <= 0:
			return PlayerAirState.new()
		return null
	
	
	func update(This : Player, Delta : float):
		
		This.AirMovement(WJAcc, WJDec, Delta)
		
		# Activate Jump buffer
		if Input.is_action_just_pressed("Jump"):
			InJumpBuffer        = true
			This.JumpBufferTime = BaseJumpBuffer
		if InJumpBuffer:
			This.JumpBufferTime -= Delta
		
		# Gradually increase the fall-speed of the WallJump
		This.CurGrav = move_toward(This.CurGrav, WJMaxGrav, WJGravMT * Delta)
		
		# Limit insane upwards momentum
		if VectorUtil.get_axis(This.velocity, This.up_direction) > EnteredUpSpd:
			This.velocity = VectorUtil.set_axis(This.velocity, EnteredUpSpd * This.up_direction)
		
		# Count down the wall jump time
		This.WallTime -= Delta
	
	
	func on_exit(This : Player):
		This.WallTime = 0

class PlayerWallJumpWeakState extends State:
	var Name = "WallJumpWeak"
	
	var InJumpBuffer : bool  = false
	var EnteredUpSpd : float
	
	
	func on_enter(This : Player):
		This.MaxAirSpd      = WallHor
		This.CurGrav        = WJGrav
		This.WallTime       = BaseWall
		This.JumpBufferTime = 0
		
		This.FacingDir        *= -1
		This.FacingDirSmoothed = This.FacingDir
		This.velocity         += This.FacingDir * WallHor
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Ground state
		if This.is_on_floor():
			return PlayerGroundState.new()
		
		# Fastfall state
		if Input.is_action_just_pressed("Skate"):
			This.DashBufferTime = BaseDashBuffer
			return PlayerFastFallState.new()
		
		# Dive state
		if Input.is_action_just_pressed("Jump") and This.ValidDive and This.DiveAmount > 0:
			return PlayerDiveState.new()
		
		# Wall climb state
		if This.is_on_wall_only() and VectorUtil.\
		make_perpendicular(This.get_wall_normal(), This.up_direction).dot(-This.DirInputPlayer) > WallAngle:
			if This.velocity.dot(This.up_direction) < 0:
				if This.get_wall_normal().dot(This.SavedWallVec) > ValidWAngle:
					This.SameWall = true
					return PlayerWallSlideState.new()
				return PlayerWallClimbState.new()
		
		# Air state
		if This.WallTime <= 0:
			return PlayerAirState.new()
		
		return null
	
	
	func update(This : Player, Delta : float):
		
		This.AirMovement(WJAcc, WJDec, Delta)
		
		# Activate Jump buffer
		if Input.is_action_just_pressed("Jump"):
			InJumpBuffer        = true
			This.JumpBufferTime = BaseJumpBuffer
		if InJumpBuffer:
			This.JumpBufferTime -= Delta
		
		# Gradually increase the fall-speed of the WallJump
		This.CurGrav = move_toward(This.CurGrav, WJMaxGrav, WJGravMT * Delta)
		
		# Limit insane upwards momentum
		if VectorUtil.get_axis(This.velocity, This.up_direction) > EnteredUpSpd:
			This.velocity = VectorUtil.set_axis(This.velocity, EnteredUpSpd * This.up_direction)
		
		# Count down the wall jump time
		This.WallTime -= Delta
	
	
	func on_exit(This : Player):
		This.WallTime = 0
		


# ////////////////////////////////////////////////////////////////////////////////////////////////
# LEDGEHOP STATE
# ////////////////////////////////////////////////////////////////////////////////////////////////

class PlayerLedgeHopState extends State:
	var Name = "LedgeHop"
	
	var InJumpBuffer : bool = false
	
	func on_enter(This : Player):
		This.velocity     = LHVer * This.up_direction
		This.velocity    += LHHor * This.FacingDir
		This.SavedWallVec = Vector3.ZERO
	
	
	func check_state(This : Player) -> State: 
		if This.GotHit: return HitState.new() 
		if This.CanBounce: return BounceState.new()
		
		# Air state
		if This.velocity.normalized().dot(This.up_direction) < 0.0:
			return PlayerAirState.new()
		
		# Fastfall state
		if Input.is_action_just_pressed("Skate"):
			return PlayerFastFallState.new()
		
		# Dive state
		if Input.is_action_just_pressed("Jump") and This.ValidDive and This.DiveAmount > 0:
			return PlayerDiveState.new()
		
		return null
	
	
	func update(This : Player, Delta : float):
		if This.is_on_wall_only():
			This.velocity  = LHVer * This.up_direction
		
		This.velocity = VectorUtil.set_except_axis(This.velocity, LHHor * This.FacingDir, This.up_direction)
		
		# Activate Jump buffer
		if Input.is_action_just_pressed("Jump"):
			InJumpBuffer        = true
			This.JumpBufferTime = BaseJumpBuffer
		if InJumpBuffer:
			This.JumpBufferTime -= Delta
	
	
	func on_exit(_This : Player):
		pass

## ////////////////////////////////////////////////////////////////////////////////////////////////
## HIT STATE
## ////////////////////////////////////////////////////////////////////////////////////////////////

class HitState extends State:
	var Name = "Hit"
	
	
	func on_enter(This : Player):
		This.velocity = VectorUtil.make_perpendicular(This.HitPos - This.global_position, This.up_direction) * -KnockBackVecH + This.up_direction * KnockBackVecV
		This.HealthAmnt -= This.DmgAmnt
		This.ChangeHealth.emit(-This.DmgAmnt)
		print("yooo we got there")
		This.IsHit = true
		This.HitTimer.start()
		pass
		
	func check_state(This : Player) -> State: 
		
		if This.velocity.normalized().dot(This.up_direction) < 0.0 and !This.IsHit:
			return PlayerAirState.new()
		
		# Fastfall state
		if Input.is_action_just_pressed("Skate") and !This.IsHit:
			return PlayerFastFallState.new()
		
		# Dive state
		if Input.is_action_just_pressed("Jump") and This.ValidDive and This.DiveAmount > 0 and !This.IsHit:
			return PlayerDiveState.new()
		return null
		
	func update(This : Player, Delta : float):
		pass
	
	func on_exit(This : Player):
		pass
	

## ////////////////////////////////////////////////////////////////////////////////////////////////
## BOUNCE STATE
## ////////////////////////////////////////////////////////////////////////////////////////////////

class BounceState extends State:
	var Name = "Bounce"
	
	
	func on_enter(This : Player):
		This.CanBounce = false
		This.velocity = This.FacingDir * This.BounceHor + This.up_direction * This.BounceVer
		
		pass
		
	func check_state(This : Player) -> State: 
		
		if This.velocity.normalized().dot(This.up_direction) < 0.0 and !This.CanBounce:
			return PlayerAirState.new()
		
		# Fastfall state
		if Input.is_action_just_pressed("Skate") and !This.CanBounce:
			return PlayerFastFallState.new()
		
		# Dive state
		if Input.is_action_just_pressed("Jump") and This.ValidDive and This.DiveAmount > 0 and !This.CanBounce:
			return PlayerDiveState.new()
		return null
		
	func update(This : Player, Delta : float):
		pass
	
	func on_exit(This : Player):
		pass
	

## ////////////////////////////////////////////////////////////////////////////////////////////////
## GRAVITY AREAS
## ////////////////////////////////////////////////////////////////////////////////////////////////

# Correctly decide the priority of a gravity area when it is entered
func AddGravityArea(EnteredGravArea : GravityArea, MainField : bool = false) -> void:
	var NewAreaInt : int = 0
	GravAreaArray.erase(EnteredGravArea)
	GravAreaArray.push_front(EnteredGravArea)
	
	if MainField:
		while len(GravAreaArray) > NewAreaInt + 1 and \
		GravAreaArray[NewAreaInt].TruePriority < GravAreaArray[NewAreaInt + 1].TruePriority:
			var Swap : GravityArea = GravAreaArray[NewAreaInt + 1]
			GravAreaArray[NewAreaInt + 1] = GravAreaArray[NewAreaInt]
			GravAreaArray[NewAreaInt] = Swap
			NewAreaInt += 1
	
	else:
		while len(GravAreaArray) > NewAreaInt + 1 and \
		GravAreaArray[NewAreaInt].TruePriority <= GravAreaArray[NewAreaInt + 1].TruePriority:
			var Swap : GravityArea = GravAreaArray[NewAreaInt + 1]
			GravAreaArray[NewAreaInt + 1] = GravAreaArray[NewAreaInt]
			GravAreaArray[NewAreaInt] = Swap
			NewAreaInt += 1

# Push an area to the front ignoring its priority
func AddGravityAreaToFirst(EnteredGravArea : GravityArea) -> void:
	GravAreaArray.erase(EnteredGravArea)
	GravAreaArray.push_front(EnteredGravArea)

func RemoveGravityArea(EnteredGravArea : GravityArea) -> void:
	GravAreaArray.erase(EnteredGravArea)


## ////////////////////////////////////////////////////////////////////////////////////////////////
## MOVEMENT
## ////////////////////////////////////////////////////////////////////////////////////////////////

func GroundMovement(This : Player, CurWalkSpd : float, Delta : float) -> float:
	var CurAcc : float
	
	# Set direction and acceleration
	if This.DirInputPlayer:
		
		# Rotate Player slowly in the direction they are pressing
		var RotDelta := This.WalkTurnSpd * Delta
		This.FacingDir = VectorUtil.\
		smove_toward(This.FacingDir, This.DirInputPlayer.normalized(), This.up_direction, RotDelta)
		
		# Set acceleration if in skid
		if CurWalkSpd < 0:
			CurAcc = This.WalkSkidAcc
		else:
			CurAcc = This.WalkAcc
	else:
		CurAcc = This.WalkDec
	
	# Smooth the direction the Player is facing in
	This.FacingDirSmoothed = VectorUtil.\
	slerp(This.FacingDirSmoothed, This.FacingDir, This.up_direction, Player.WalkTurnLerp * Delta).normalized()
	
	# Set the Player's walking velocity
	var TargetSpd : float = max(0, This.BaseWalkSpd * This.FacingDir.dot(This.DirInputPlayer))
	CurWalkSpd = move_toward(CurWalkSpd, TargetSpd, CurAcc * Delta)
	This.velocity = VectorUtil.set_except_axis(This.velocity, This.FacingDir * CurWalkSpd, This.up_direction)
	
	return CurWalkSpd

func SkateGroundMovement(CurSkateSpd : float, Delta : float) -> float:
	
	# Rotate Player slowly in the direction they are pressing
	var RotDelta := SkateTurnSpd * Delta
	FacingDir = VectorUtil.\
	smove_toward(FacingDir, DirInputPlayer, up_direction, RotDelta)
	
	# Smooth the direction the Player is facing in
	FacingDirSmoothed = VectorUtil.\
	slerp(FacingDirSmoothed, FacingDir, up_direction, Player.SkateTurnLerp * Delta).normalized()
	
	# Set the Player's walking velocity
	CurSkateSpd = move_toward(CurSkateSpd, BaseSkateSpd, SkateAcc * Delta)
	velocity = VectorUtil.set_except_axis(velocity, FacingDir * CurSkateSpd, up_direction)
	
	return CurSkateSpd


func AirMovement(EnteredAirAcc: float, EnteredAirDec: float, Delta : float) -> void:
	var HorizontalVel : Vector3 = VectorUtil.remove_axis(velocity, up_direction)
	var TargetVel     : Vector3 = DirInputPlayer * MaxAirSpd
	
	# Limit the max speed of the Player slowly
	if MaxAirSpd > OrbitalLimit * sqrt(CurGrav):
		MaxAirSpd = move_toward(MaxAirSpd, OrbitalLimit * sqrt(CurGrav), Delta * EnteredAirDec)
	
	# Set the horizontal velocity while not changing the vertical speed of the Player
	if DirInputPlayer:
		if HorizontalVel.length_squared() > TargetVel.length_squared():
			HorizontalVel = HorizontalVel.move_toward(TargetVel, Delta * EnteredAirDec)
		else:
			HorizontalVel = HorizontalVel.move_toward(TargetVel, Delta * EnteredAirAcc)
	elif !Input.is_action_pressed("Jump"):
		HorizontalVel = HorizontalVel.move_toward(TargetVel, Delta * EnteredAirDec)
	velocity = VectorUtil.set_except_axis(velocity, HorizontalVel, up_direction)
	
	# Set the direction the Player is facing correctly
	if HorizontalVel:
		FacingDir = VectorUtil.smove_toward(FacingDir, HorizontalVel.normalized(), up_direction, AirTurnSpd * Delta)
	
	FixFacingDir()
	FacingDirSmoothed = FacingDirSmoothed.slerp(FacingDir, AirTurnLerp * Delta).normalized()


func SpinMovement(TargetSpd : float, Delta : float) -> void:
	var HorizontalVel : Vector3 = VectorUtil.remove_axis(velocity, up_direction)
	var TargetVel     : Vector3 = DirInputPlayer * TargetSpd
	
	# Set the horizontal velocity while not changing the vertical speed of the Player
	if DirInputPlayer:
		HorizontalVel = HorizontalVel.move_toward(TargetVel, Delta * SpinAcc)
	else:
		HorizontalVel = HorizontalVel.move_toward(TargetVel, Delta * SpinDec)
	velocity = VectorUtil.set_except_axis(velocity, HorizontalVel, up_direction)
	
	# Set the direction the Player is facing correctly
	if HorizontalVel:
		FacingDir = VectorUtil.smove_toward(FacingDir, HorizontalVel.normalized(), up_direction, AirTurnSpd * Delta)
	
	FixFacingDir()
	FacingDirSmoothed = FacingDirSmoothed.slerp(FacingDir, AirTurnLerp * Delta).normalized()


## ////////////////////////////////////////////////////////////////////////////////////////////////
## GAME FEEL
## ////////////////////////////////////////////////////////////////////////////////////////////////

func FOVEffect(ChangeAmout : float = 10.0) -> void:
	MainCam.CurFOV += ChangeAmout

func ThumpCamEffect(ChangeAmout : Vector2 = Vector2(0, -2.0)) -> void:
	MainCam.SetShake += ChangeAmout

# Avoid scary bugs
func FixFacingDir() -> void:
	if roundi(FacingDir.length()) != 1: 
		FacingDir = Vector3.FORWARD
		FacingDir = VectorUtil.make_perpendicular(FacingDir, up_direction)
		FacingDirSmoothed = FacingDir
	if FacingDirSmoothed == Vector3.ZERO: 
		FacingDirSmoothed = Vector3.FORWARD
		FacingDirSmoothed = VectorUtil.make_perpendicular(FacingDirSmoothed, up_direction)


func _on_hit_box_area_entered(area: Area3D) -> void:
		
	if area.is_in_group("Boalb"):
		BoalbSignal.emit(area.BoalbAmount)
		print(area.BoalbAmount)
	
	if area.is_in_group("HitBox"):
		HitPos = area.global_position 
		DmgAmnt = area.DmgAmnt
		GotHit = true

func _on_hit_timer_timeout() -> void:
		GotHit = false
		IsHit = false

func Bounce(Hor : float, Ver : float):
	BounceHor = Hor
	BounceVer = Ver
	CanBounce = true
