class_name DeskReport
extends Node3D

@export var decision_ui: ReportDecisionUI
@export var diegetic_display: DiegeticUIDisplay
@export var interaction_router: InteractionRouter

var _current_employee: EmployeeData


func _ready() -> void:
	if decision_ui == null and diegetic_display:
		decision_ui = diegetic_display.get_ui() as ReportDecisionUI
	if decision_ui:
		decision_ui.show_employee(_current_employee)
		if not decision_ui.layoff_chosen.is_connected(choose_layoff):
			decision_ui.layoff_chosen.connect(choose_layoff)
	if diegetic_display:
		diegetic_display.set_input_active(false)


func on_interact() -> void:
	if decision_ui:
		decision_ui.show_employee(_current_employee)
	if diegetic_display:
		diegetic_display.set_input_active(true)


func on_deselect() -> void:
	if diegetic_display:
		diegetic_display.set_input_active(false)


func set_employee(employee: EmployeeData) -> void:
	_current_employee = employee
	if decision_ui:
		decision_ui.show_employee(_current_employee)


func choose_layoff(motive: GlobalVariables.LayoffMotive) -> void:
	score_layoff_choice(motive, _current_employee)
	advance_to_next_report()
	if interaction_router:
		interaction_router.request_deselect()
	else:
		on_deselect()


func score_layoff_choice(_choice: GlobalVariables.LayoffMotive, _report: EmployeeData) -> void:
	pass


func advance_to_next_report() -> void:
	pass
