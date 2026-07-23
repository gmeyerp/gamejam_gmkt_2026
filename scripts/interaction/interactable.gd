class_name Interactable
extends Area3D

signal interacted(interactable: Interactable)

@export var focus_marker: Node3D
@export var owner_object: Node
@export var interaction_enabled: bool = true:
	set(value):
		interaction_enabled = value
		_apply_enabled_state()


func _ready() -> void:
	if owner_object == null:
		owner_object = get_parent()
	if focus_marker == null:
		focus_marker = get_node_or_null("../FocusMarker") as Node3D
	collision_layer = 1
	collision_mask = 0
	monitoring = false
	monitorable = true
	_apply_enabled_state()


func get_focus_target() -> Node3D:
	if focus_marker:
		return focus_marker
	return self


func get_owner_object() -> Node:
	if owner_object:
		return owner_object
	return get_parent()


func notify_interacted() -> void:
	if not interaction_enabled:
		return
	interacted.emit(self)


func _apply_enabled_state() -> void:
	set_deferred("input_ray_pickable", interaction_enabled)
	for child in get_children():
		if child is CollisionShape3D:
			child.disabled = not interaction_enabled
