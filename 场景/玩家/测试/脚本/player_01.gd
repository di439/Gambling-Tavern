class_name Player
extends CharacterBody3D

@onready var camera_rig: Node3D = $Camera
@onready var subject: Node3D = $Camera/subject
@onready var camera: Camera3D = $Camera/subject/Camera3D

@export_group("移动")
@export var walk_speed := 3.0
@export var run_speed := 5.0
@export var acceleration := 10.0
@export var friction := 30.0

@export_group("跳跃")
@export var jump_strength := 15.0
@export var jump_height := 2.25
@export var jump_time_to_peak := 0.3
@export var jump_time_to_descent := 0.3
@onready var jump_gravity := (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity := (2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)

@export_group("视角")
@export var mouse_sensitivity := 0.004
@export var view_smoothing := 15.0

@export_group("走路晃动")
@export var bob_frequency := 0.35
@export var bob_tilt := 0.03
@export var bob_pitch := 0.02
@export var bob_speed_threshold := 0.1

@export_group("方向倾斜")
@export var direction_offset := 0.15
@export var direction_pitch := 0.15
@export var direction_roll := 0.05
@export var motion_smoothing := 5.0

var move_input := Vector2.ZERO
var target_yaw := 0.0
var target_pitch := 0.0
var bob_time := 0.0
var current_offset := Vector3.ZERO
var current_rot := Vector3.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		return
	if event is InputEventMouseMotion:
		target_yaw -= event.relative.x * mouse_sensitivity
		target_pitch -= event.relative.y * mouse_sensitivity
		target_pitch = clamp(target_pitch, -PI/3, PI/3)

func _process(delta: float) -> void:
	update_view(delta)
	apply_camera_motion(delta)

func _physics_process(delta: float) -> void:
	update_move_input()
	update_velocity(delta)
	apply_gravity(delta)
	move_and_slide()

func update_view(delta: float) -> void:
	camera_rig.rotation.y = lerp_angle(camera_rig.rotation.y, target_yaw, delta * view_smoothing)
	camera.rotation.x = lerp(camera.rotation.x, target_pitch, delta * view_smoothing)

func update_move_input() -> void:
	move_input = Input.get_vector("left", "right", "forward", "backward")

func update_velocity(delta: float) -> void:
	var speed := run_speed if Input.is_action_pressed("run") else walk_speed
	var world_dir := move_input.rotated(-camera_rig.global_rotation.y)
	var vel := Vector2(velocity.x, velocity.z)
	if world_dir:
		vel += world_dir * delta * speed * acceleration
		vel = vel.limit_length(speed)
	else:
		vel = vel.move_toward(Vector2.ZERO, speed * friction * delta)
	velocity.x = vel.x
	velocity.z = vel.y

func apply_gravity(delta: float) -> void:
	var gravity := jump_gravity if velocity.y > 0 else fall_gravity
	velocity.y -= gravity * delta

func apply_camera_motion(delta: float) -> void:
	subject.position -= current_offset
	subject.rotation.x -= current_rot.x
	subject.rotation.z -= current_rot.z
	
	var target_offset := calculate_direction_offset()
	var target_rot := calculate_direction_rot() + calculate_bob_rot(delta)
	current_offset = current_offset.lerp(target_offset, delta * motion_smoothing)
	current_rot = current_rot.lerp(target_rot, delta * motion_smoothing)
	
	subject.position += current_offset
	subject.rotation.x += current_rot.x
	subject.rotation.z += current_rot.z

func calculate_direction_offset() -> Vector3:
	if move_input.length() < 0.1:
		return Vector3.ZERO
	return Vector3(-move_input.x * direction_offset, 0, -move_input.y * direction_offset)

func calculate_direction_rot() -> Vector3:
	if move_input.length() < 0.1:
		return Vector3.ZERO
	return Vector3(move_input.y * direction_pitch, 0, -move_input.x * direction_roll)

func calculate_bob_rot(delta: float) -> Vector3:
	var speed := Vector2(velocity.x, velocity.z).length()
	if speed <= bob_speed_threshold or not is_on_floor():
		bob_time = 0.0
		return Vector3.ZERO
	bob_time += delta * speed * 0.5
	var phase := bob_time * bob_frequency * TAU
	return Vector3(sin(phase) * bob_pitch, 0, cos(phase * 0.5) * bob_tilt)
