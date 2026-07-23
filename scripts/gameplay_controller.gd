class_name GameplayController
extends Node

@export var title_ui: Control
@export var camera: CameraController
@export var interaction_router: InteractionRouter
@export var pc_focus_marker: Marker3D


func _ready() -> void:
	_enter_menu()


func on_start_game_pressed() -> void:
	_begin_play()


func _enter_menu() -> void:
	if interaction_router:
		interaction_router.set_active(false)
	if camera and pc_focus_marker:
		camera.edge_look_enabled = false
		camera.snap_focus(pc_focus_marker)


func _begin_play() -> void:
	if title_ui:
		title_ui.visible = false
		title_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if camera:
		camera.edge_look_enabled = true
		camera.set_mode(CameraController.Mode.FREE)
	if interaction_router:
		interaction_router.set_active(true)
