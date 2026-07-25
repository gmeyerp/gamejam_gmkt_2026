extends Node3D
class_name DeskComputer

@export var os_ui: Control
@export var diegetic_display: DiegeticUIDisplay
@export var interaction_router: InteractionRouter

func _ready() -> void:
	if os_ui == null and diegetic_display:
		os_ui = diegetic_display.get_ui()

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

func _refresh_open_rulebook() -> void:
	if os_ui == null or not os_ui.has_method("get_rulebook"):
		return
	var rulebook: Control = os_ui.get_rulebook()
	if rulebook and rulebook.visible and rulebook.has_method("show_ui"):
		rulebook.show_ui()
