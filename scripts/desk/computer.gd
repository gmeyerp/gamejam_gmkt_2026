class_name DeskComputer
extends Node3D

@export var rulebook_ui: ComputerRulebookUI
@export var diegetic_display: DiegeticUIDisplay
@export var interaction_router: InteractionRouter


func _ready() -> void:
	if rulebook_ui == null and diegetic_display:
		rulebook_ui = diegetic_display.get_ui() as ComputerRulebookUI
	if rulebook_ui:
		rulebook_ui.set_department_data(get_department_averages(GlobalVariables.Department.Office))
		rulebook_ui.show_ui()
	if diegetic_display:
		diegetic_display.set_input_active(false)


func on_interact() -> void:
	if rulebook_ui:
		rulebook_ui.set_department_data(get_department_averages(GlobalVariables.Department.Office))
		rulebook_ui.show_ui()
	if diegetic_display:
		diegetic_display.set_input_active(true)


func on_deselect() -> void:
	if diegetic_display:
		diegetic_display.set_input_active(false)


func get_department_averages(_dept: GlobalVariables.Department) -> Dictionary:
	return {}
