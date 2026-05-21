extends Node3D


## ////////////////////////////////////////////////////////////////////////////////////////////////
## CHILDREN
## ////////////////////////////////////////////////////////////////////////////////////////////////

# CAM /////////////////////////////////////////////////////////////////////////////////////////////

@onready var RotP   : Node3D = $RotatePoint
@onready var CamDis : SpringArm3D = $RotatePoint/CamDis
@onready var Cam    : Camera3D    = $RotatePoint/CamDis/Cam


## ////////////////////////////////////////////////////////////////////////////////////////////////
## VARIABLES
## ////////////////////////////////////////////////////////////////////////////////////////////////

# CAMERA ANGLE VARIABLES //////////////////////////////////////////////////////////////////////////

const MaxAngle : float = 0.3
const MinAngle : float = -1.5

const MouseSens      : float = 0.005
const ControllerSens : float = 0.05
const RotationStr    : float = 10.0

var TargetRotation : Vector3


# CAMERA FOV VARIABLES ////////////////////////////////////////////////////////////////////////////

const CurFOVStr       : float = 2.0
const FOVStr          : float = 6.0
const MaxTargetFOVStr : float = 1.4

var CurFOV    : float
var TargetFOV : float
var MaxFOV    : float


# CAMERA SHAKE VARIABLES //////////////////////////////////////////////////////////////////////////

const CurShakeStr : float = 3.0
const ShakeStr    : float = 6.0
const MaxShake    : float = 2.0

var SetShake    : Vector2
var TargetShake : float


## ////////////////////////////////////////////////////////////////////////////////////////////////
## READY
## ////////////////////////////////////////////////////////////////////////////////////////////////

func _ready() -> void:
	TargetFOV = Cam.fov
	MaxFOV    = TargetFOV * MaxTargetFOVStr


## ////////////////////////////////////////////////////////////////////////////////////////////////
## PROCESS
## ////////////////////////////////////////////////////////////////////////////////////////////////

func _physics_process(Delta: float) -> void:
	
	# CAMERA ANGLE ////////////////////////////////////////////////////////////////////////////////
	
	# Set target rotation with the right stick
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var InputDir  : Vector2 = Input.get_vector("AimLeft", "AimRight", "AimUp", "AimDown")
		
		TargetRotation.x -= InputDir.normalized().y * ControllerSens
		TargetRotation.y -= InputDir.normalized().x * ControllerSens
		
	# Clamp and wrap rotation to not let it increase infinitely
	TargetRotation.x = clampf(TargetRotation.x, MinAngle, MaxAngle)
	TargetRotation.y = wrapf(TargetRotation.y, 0, TAU)
	
	# Lerp rotation
	RotP.rotation.x = lerp_angle(RotP.rotation.x, TargetRotation.x, min(1.0, RotationStr * Delta))
	RotP.rotation.y = lerp_angle(RotP.rotation.y, TargetRotation.y, min(1.0, RotationStr * Delta))
	
	
	# FOV /////////////////////////////////////////////////////////////////////////////////////////
	
	CurFOV  = minf(CurFOV, MaxFOV)
	Cam.fov = lerpf(Cam.fov, CurFOV, Delta * FOVStr)
	CurFOV  = lerpf(CurFOV, TargetFOV, Delta * CurFOVStr)
	
	
	# SHAKE ///////////////////////////////////////////////////////////////////////////////////////
	
	SetShake.x   = minf(SetShake.x, MaxShake)
	SetShake.x   = maxf(SetShake.x, -MaxShake)
	SetShake.y   = minf(SetShake.y, MaxShake)
	SetShake.y   = maxf(SetShake.y, -MaxShake)
	Cam.h_offset = lerpf(Cam.h_offset, SetShake.x, Delta * ShakeStr)
	Cam.v_offset = lerpf(Cam.v_offset, SetShake.y, Delta * ShakeStr)
	SetShake.x   = lerpf(SetShake.x, 0, Delta * CurShakeStr)
	SetShake.y   = lerpf(SetShake.y, 0, Delta * CurShakeStr)


## ////////////////////////////////////////////////////////////////////////////////////////////////
## INPUT (Used for camera angle)
## ////////////////////////////////////////////////////////////////////////////////////////////////

func _input(Event: InputEvent) -> void:
	
	# CAMERA ANGLE ////////////////////////////////////////////////////////////////////////////////
	
	# Rotate the camera when moving the mouse or using the right stick of a controller
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		
		# Set target rotation with the mouse
		if Event is InputEventMouseMotion:
			TargetRotation.x -= Event.relative.y * MouseSens
			TargetRotation.y -= Event.relative.x * MouseSens
