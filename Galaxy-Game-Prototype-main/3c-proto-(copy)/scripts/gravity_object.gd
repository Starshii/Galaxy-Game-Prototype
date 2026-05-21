class_name GravityObject extends CharacterBody3D

# GENERAL /////////////////////////////////////////////////////////////////////////////////////////

# SET PLAYER UP SMOOTHLY
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
var UpdateUpDir : bool = true

# GRAVITY
const BaseTermVel     : float = 90.0   # Max velocity the player can move in any direction
const BaseFallTermVel : float = 30.0
const BaseGrav        : float = 40.0
const SkateGrav       : float = 60.0
const GravRampStr     : float = 0.3    # Used to make it harder for the player to get into orbit
const OrbitalLimit    : float = 2.0

var GravStr        : float = 1.0   # Some places might have more gravity than others
var CurGrav        : float = BaseGrav
var CurFallTermVel : float = BaseFallTermVel

var GravAreaArray : Array[GravityArea]
var update_basis   : bool = true

func _ready() -> void:
	DirInput.x =1
	visible           = true
	UpDirLinVec       = up_direction
	FacingDir         = -global_basis.z
	FacingDirSmoothed = -global_basis.z
	DirInputPlayer    = -global_basis.z
	SkateInput        = Vector2.DOWN

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


func _physics_process(delta: float) -> void:
	# UP DIRECTION LINEAR /////////////////////////////////////////////////////////////////////////
	if update_basis:
		global_basis.y = up_direction
		global_basis.z = VectorUtil.make_perpendicular(global_basis.z, up_direction)
		global_basis.x = up_direction.cross(global_basis.z)
	# Used for smooth changes to player's basis
	var UpDirLinAxis := UpDirLinVec.cross(up_direction)
	if UpDirLinAxis.length_squared() > 0.01:
		UpDirLinAxis = UpDirLinAxis.normalized()
		UpDirLinVec = VectorUtil.smove_toward(UpDirLinVec, up_direction, UpDirLinAxis, delta * UpDirLinSpd)
	else:
		UpDirLinVec = up_direction
	
	
	# TRUE FACING DIRECTION ///////////////////////////////////////////////////////////////////////
	
	FacingDirSmoothed = VectorUtil.make_perpendicular(FacingDirSmoothed, UpDirLinVec).normalized()
	if FacingDirSmoothed.cross(UpDirLinVec) != Vector3.ZERO:
		global_basis = Basis.looking_at(FacingDirSmoothed, UpDirLinVec)
# /////////////////////////////////////////////////////////////////////////////////////////////
	# GRAVITY AREA SORTING AND UP-DIRECTION
	# /////////////////////////////////////////////////////////////////////////////////////////////
	
	# GRAVITY AREAS ///////////////////////////////////////////////////////////////////////////////
	if len(GravAreaArray) > 0:
		
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
		
		# Set the facing direction of the player correctly with the new gravity field
		FacingDir = VectorUtil.make_perpendicular(FacingDir, up_direction)
	
	
	# GRAVITY AND TERMINAL VELOCITY ///////////////////////////////////////////////////////////////
	
	# Certain planets might have a stronger gravity, GravStr is used in that case
	velocity -= up_direction * CurGrav * GravStr * delta
	
	# The player can only move at a certain speed towards the ground
	if VectorUtil.get_axis(velocity, -up_direction) > CurFallTermVel:
		var VelHor : float = VectorUtil.get_axis(velocity, FacingDir)
		velocity = VelHor * FacingDir + CurFallTermVel * -up_direction
	
	# The player can't exceed terminal velocity
	if velocity.length() > BaseTermVel:
		velocity = velocity.normalized() * BaseTermVel
	
	FacingDirSmoothed = FacingDirSmoothed.slerp(FacingDir, 30 * delta).normalized()
	
	move_and_slide()
