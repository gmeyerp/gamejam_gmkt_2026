class_name GameplayController
extends Node

@export var title_ui: Control
@export var camera: CameraController
@export var interaction_router: InteractionRouter
@export var pc_focus_marker: Marker3D
@export var desk_computer: DeskComputer

func _ready() -> void:
	enter_menu()

func on_start_game_pressed() -> void:
	_begin_play()

func enter_menu() -> void:
	if interaction_router:
		interaction_router.set_active(false)

	if camera and pc_focus_marker:
		camera.edge_look_enabled = false
		camera.snap_focus(pc_focus_marker)

	if desk_computer:
		desk_computer.set_menu_input_active(true)

	if title_ui:
		title_ui.visible = false
		title_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _begin_play() -> void:
	if title_ui:
		title_ui.visible = false
		title_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE

	if camera:
		camera.edge_look_enabled = true
		camera.set_mode(CameraController.Mode.FREE)

	if interaction_router:
		interaction_router.set_active(true)
