class_name CameraController
extends Camera3D

signal mode_changed(mode: Mode)
signal focus_changed(is_focused: bool)

enum Mode { FREE, DESK }

@export_group("Anchors")
@export var free_anchor: Marker3D
@export var desk_anchor: Marker3D

@export_group("Free pan limits (radians)")
@export var free_yaw_left: float = 0.55
@export var free_yaw_right: float = 0.55
@export var free_pitch_up: float = 0.3
@export var free_pitch_down: float = 0.3

@export_group("Desk pan limits (radians)")
@export var desk_yaw_left: float = 0.22
@export var desk_yaw_right: float = 0.22
@export var desk_pitch_up: float = 0.16
@export var desk_pitch_down: float = 0.16
@export_group("Edge look")
@export var edge_margin: float = 0.08
@export var edge_look_enabled: bool = true
@export var invert_horizontal_pan: bool = false

@export_group("Motion")
@export var focus_lerp_speed: float = 10.0
@export var mode_lerp_speed: float = 8.0

var mode: Mode = Mode.FREE
var _focus_target: Node3D = null
var _yaw_offset: float = 0.0
var _pitch_offset: float = 0.0
var _free_transform: Transform3D
var _desk_transform: Transform3D


func _ready() -> void:
	current = true
	_resolve_anchors()
	refresh_anchors()


func _process(delta: float) -> void:
	if _focus_target and is_instance_valid(_focus_target):
		global_transform = global_transform.interpolate_with(
			_focus_target.global_transform,
			1.0 - exp(-focus_lerp_speed * delta)
		)
		return

	if edge_look_enabled:
		_update_edge_look()
	else:
		_yaw_offset = 0.0
		_pitch_offset = 0.0

	var base := _desk_transform if mode == Mode.DESK else _free_transform
	var target := _build_look_transform(base, _yaw_offset, _pitch_offset)
	global_transform = global_transform.interpolate_with(
		target,
		1.0 - exp(-mode_lerp_speed * delta)
	)


func _resolve_anchors() -> void:
	if free_anchor == null:
		free_anchor = get_node_or_null("../FreeAnchor") as Marker3D
	if desk_anchor == null:
		desk_anchor = get_node_or_null("../DeskAnchor") as Marker3D


func refresh_anchors() -> void:
	_resolve_anchors()
	if free_anchor:
		_free_transform = free_anchor.global_transform
	if desk_anchor:
		_desk_transform = desk_anchor.global_transform


func set_mode(new_mode: Mode) -> void:
	clear_focus()
	adopt_mode(new_mode)


func adopt_mode(new_mode: Mode) -> void:
	mode = new_mode
	_yaw_offset = 0.0
	_pitch_offset = 0.0
	refresh_anchors()
	mode_changed.emit(mode)


func focus(target: Node3D) -> void:
	if target == null:
		return
	_focus_target = target
	_yaw_offset = 0.0
	_pitch_offset = 0.0
	focus_changed.emit(true)


func snap_focus(target: Node3D) -> void:
	focus(target)
	if target:
		global_transform = target.global_transform


func clear_focus() -> void:
	if _focus_target == null:
		return
	_focus_target = null
	focus_changed.emit(false)


func is_focused() -> bool:
	return _focus_target != null


func _update_edge_look() -> void:
	var mouse := get_viewport().get_mouse_position()
	var size := get_viewport().get_visible_rect().size
	if size.x <= 0.0 or size.y <= 0.0:
		return

	var nx := mouse.x / size.x
	var ny := mouse.y / size.y
	var yaw_left := desk_yaw_left if mode == Mode.DESK else free_yaw_left
	var yaw_right := desk_yaw_right if mode == Mode.DESK else free_yaw_right
	var pitch_up := desk_pitch_up if mode == Mode.DESK else free_pitch_up
	var pitch_down := desk_pitch_down if mode == Mode.DESK else free_pitch_down

	var look_left_sign := -1.0 if invert_horizontal_pan else 1.0
	var look_right_sign := 1.0 if invert_horizontal_pan else -1.0

	_yaw_offset = 0.0
	if nx < edge_margin:
		_yaw_offset = look_left_sign * yaw_left * (1.0 - nx / edge_margin)
	elif nx > 1.0 - edge_margin:
		_yaw_offset = look_right_sign * yaw_right * ((nx - (1.0 - edge_margin)) / edge_margin)

	_pitch_offset = 0.0
	if ny < edge_margin:
		_pitch_offset = pitch_up * (1.0 - ny / edge_margin)
	elif ny > 1.0 - edge_margin:
		_pitch_offset = -pitch_down * ((ny - (1.0 - edge_margin)) / edge_margin)


func _build_look_transform(base: Transform3D, yaw: float, pitch: float) -> Transform3D:
	var basis := base.basis
	basis = basis.rotated(basis.y.normalized(), yaw)
	basis = basis.rotated(basis.x.normalized(), pitch)
	return Transform3D(basis.orthonormalized(), base.origin)
