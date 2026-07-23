class_name InteractionRouter
extends Node

@export var camera: CameraController
@export var desk_surface: Interactable
@export var desk_objects: Array[Interactable] = []
@export var ray_length: float = 100.0
@export var collide_with_areas: bool = true
@export var collide_with_bodies: bool = true

var _active: bool = false
var _current_owner: Node = null
var _signals_bound: bool = false


func _ready() -> void:
	set_process_unhandled_input(false)
	_bind_camera_signals()
	_refresh_interactable_enabled()


func set_active(value: bool) -> void:
	_active = value
	set_process_unhandled_input(value)
	_refresh_interactable_enabled()


func request_deselect() -> void:
	_handle_rmb()


func _bind_camera_signals() -> void:
	if camera == null or _signals_bound:
		return
	camera.mode_changed.connect(_on_camera_mode_changed)
	camera.focus_changed.connect(_on_camera_focus_changed)
	_signals_bound = true


func _unhandled_input(event: InputEvent) -> void:
	if not _active or camera == null:
		return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if camera.is_focused():
				return
			_handle_lmb()
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_handle_rmb()
			get_viewport().set_input_as_handled()


func _handle_lmb() -> void:
	if camera.is_focused():
		return
	var interactable := _pick_interactable()
	if interactable == null or not interactable.interaction_enabled:
		return
	_interact(interactable)


func _handle_rmb() -> void:
	if camera.is_focused():
		_deselect_current()
		return
	if camera.mode == CameraController.Mode.DESK:
		camera.set_mode(CameraController.Mode.FREE)
		_refresh_interactable_enabled()


func _interact(interactable: Interactable) -> void:
	var owner_node := interactable.get_owner_object()
	interactable.notify_interacted()

	if owner_node is DeskSurface:
		camera.set_mode(CameraController.Mode.DESK)
		if owner_node.has_method("on_interact"):
			owner_node.on_interact()
		_refresh_interactable_enabled()
		return

	if camera.mode != CameraController.Mode.DESK:
		camera.adopt_mode(CameraController.Mode.DESK)
	elif _current_owner and _current_owner != owner_node:
		if _current_owner.has_method("on_deselect"):
			_current_owner.on_deselect()

	_current_owner = owner_node
	camera.focus(interactable.get_focus_target())
	if owner_node and owner_node.has_method("on_interact"):
		owner_node.on_interact()
	_refresh_interactable_enabled()


func _deselect_current() -> void:
	if _current_owner and _current_owner.has_method("on_deselect"):
		_current_owner.on_deselect()
	_current_owner = null
	camera.clear_focus()
	_refresh_interactable_enabled()


func _refresh_interactable_enabled() -> void:
	var focused := camera != null and camera.is_focused()
	var is_free := camera == null or camera.mode == CameraController.Mode.FREE

	if desk_surface:
		desk_surface.interaction_enabled = _active and is_free and not focused

	for interactable in desk_objects:
		if interactable:
			interactable.interaction_enabled = _active and not focused


func _on_camera_mode_changed(_mode: CameraController.Mode) -> void:
	_refresh_interactable_enabled()


func _on_camera_focus_changed(_is_focused: bool) -> void:
	_refresh_interactable_enabled()


func _pick_interactable() -> Interactable:
	var space := camera.get_world_3d().direct_space_state
	var mouse := get_viewport().get_mouse_position()
	var from := camera.project_ray_origin(mouse)
	var to := from + camera.project_ray_normal(mouse) * ray_length

	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = collide_with_areas
	query.collide_with_bodies = collide_with_bodies

	var result := space.intersect_ray(query)
	if result.is_empty():
		return null

	var collider = result.get("collider")
	if collider is Interactable:
		return collider
	if collider is Node:
		return _find_interactable_ancestor(collider)
	return null


func _find_interactable_ancestor(node: Node) -> Interactable:
	var current := node
	while current:
		if current is Interactable:
			return current
		current = current.get_parent()
	return null
