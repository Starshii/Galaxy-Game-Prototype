extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005
const launchSpeed = 6

var warpTime : float = 3
@onready var head : Node3D = $Head

@export var telescopeCam: Camera3D
@export var playerCam: Camera3D

@onready var telescopeRay: RayCast3D = $Head/TelescopeCam/RayCast3D
var targetTransform: Transform3D
var isTravelling: bool
var OGCamRot: Vector3
var isIntelescope: bool
var hit

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotation.x -= event.relative.y * SENSITIVITY
		head.rotation.y -= event.relative.x * SENSITIVITY
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-40), deg_to_rad(90))

func _ready() -> void:
	playerCam.make_current()
	OGCamRot = telescopeCam.rotation
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	TelescopeFunction()
	if !isTravelling: 
	# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
		if Input.is_action_just_pressed("telescope"):
			InTelescope()
		if Input.is_action_just_released("telescope"): 
			OutTelescope()
	
	move_and_slide()
	
func InTelescope() -> void:
	telescopeCam.make_current()
	isIntelescope = true
	
func OutTelescope() -> void: 
	playerCam.make_current()
	isIntelescope = false
	
func TelescopeFunction() -> void:
	if isIntelescope:
		if telescopeRay.is_colliding():
			hit = telescopeRay.get_collision_point()
			
		if Input.is_action_just_pressed("Launch"):
			if hit != null:
				GoToPlanet()

func GoToPlanet() -> void:
	#spin and then movetowards
	isTravelling = true
	playerCam.make_current()
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(head, "global_rotation", Vector3(global_rotation.x, TAU , global_rotation.z), warpTime)
	tween.tween_property(self, "position", Vector3(hit),warpTime)
	
	await get_tree().create_timer(warpTime).timeout

	isTravelling = false
	velocity = Vector3.ZERO

	
