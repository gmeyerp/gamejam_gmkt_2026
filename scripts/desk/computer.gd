extends Node3D
class_name DeskComputer

@export var os_ui: Control
@export var diegetic_display: DiegeticUIDisplay
@export var interaction_router: InteractionRouter
@export var monitor_screen: MeshInstance3D
@export var monitor_body: Node3D

func _ready() -> void:
	if os_ui == null and diegetic_display:
		os_ui = diegetic_display.get_ui()

	_bind_monitor_screen()

	if diegetic_display:
		diegetic_display.set_input_active(false)

func on_interact() -> void:
	_refresh_open_rulebook()
	if diegetic_display:
		diegetic_display.set_input_active(true)

func on_deselect() -> void:
	if diegetic_display:
		diegetic_display.set_input_active(false)

func set_menu_input_active(active: bool) -> void:
	if diegetic_display:
		diegetic_display.set_input_active(active)

func _bind_monitor_screen() -> void:
	if diegetic_display == null:
		return
	var screen := monitor_screen
	if screen == null and monitor_body:
		screen = _find_child_screen(monitor_body)
	if screen:
		diegetic_display.follow_screen(screen)

func _find_child_screen(body: Node3D) -> MeshInstance3D:
	if body == null:
		return null
	for child in body.get_children():
		if child is MeshInstance3D:
			var child_name := String(child.name)
			if child_name.begins_with("ScreenMesh") or child_name.begins_with("MonitorScreen"):
				return child
	return null

func _refresh_open_rulebook() -> void:
	if os_ui == null or not os_ui.has_method("get_rulebook"):
		return
	var rulebook: Control = os_ui.get_rulebook()
	if rulebook and rulebook.visible and rulebook.has_method("show_ui"):
		rulebook.show_ui()
