extends Node3D
class_name DeskComputer

@export var rulebook_ui: ComputerRulebookUI
@export var diegetic_display: DiegeticUIDisplay
@export var interaction_router: InteractionRouter

func _ready() -> void:
	if rulebook_ui == null and diegetic_display:
		rulebook_ui = diegetic_display.get_ui() as ComputerRulebookUI
		
	_update_computer_ui()
	
	if diegetic_display:
		diegetic_display.set_input_active(false)

func on_interact() -> void:
	_update_computer_ui()
	if diegetic_display:
		diegetic_display.set_input_active(true)

func on_deselect() -> void:
	if diegetic_display:
		diegetic_display.set_input_active(false)

func _update_computer_ui() -> void:
	if rulebook_ui:
		var current_dept = GlobalVariables.Department.Office
		rulebook_ui.set_department_data(get_department_averages(current_dept))
		rulebook_ui.show_ui()

func get_department_averages(dept: GlobalVariables.Department) -> Dictionary:
	var avg_salary = EmployeeList.get_average_salary(dept)
	var avg_productivity = EmployeeList.get_average_productivity(dept)
	
	return {
		"department": dept,
		"average_salary": avg_salary,
		"average_productivity": avg_productivity
	}
