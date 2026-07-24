extends Node3D
class_name DeskReport

signal player_scored(score: int)
signal employee_fired(employee: EmployeeData)

@export var decision_ui: ReportDecisionUI
@export var diegetic_display: DiegeticUIDisplay
@export var interaction_router: InteractionRouter

var _current_employee: EmployeeData

func _ready() -> void:
	if decision_ui == null and diegetic_display:
		decision_ui = diegetic_display.get_ui() as ReportDecisionUI
	if decision_ui:
		if not decision_ui.layoff_chosen.is_connected(choose_layoff):
			decision_ui.layoff_chosen.connect(choose_layoff)
	if diegetic_display:
		diegetic_display.set_input_active(false)

func on_interact() -> void:
	if decision_ui and _current_employee:
		decision_ui.show_employee(_current_employee)
	if diegetic_display:
		diegetic_display.set_input_active(true)

func on_deselect() -> void:
	if diegetic_display:
		diegetic_display.set_input_active(false)

func set_employee(employee: EmployeeData) -> void:
	if not employee:
		return
	print(employee.name)
	_current_employee = employee
	if decision_ui:
		decision_ui.show_employee(employee)
	if diegetic_display and diegetic_display.input_active:
		diegetic_display.set_input_active(true)

func choose_layoff(motive: GlobalVariables.LayoffMotive) -> void:
	score_layoff_choice(motive, _current_employee)
	employee_fired.emit(_current_employee)

func score_layoff_choice(_choice: GlobalVariables.LayoffMotive, _report: EmployeeData) -> void:
	if not _report:
		return
		
	print(str(_choice) + "/" + str(_report.layoff_motive))
	
	if _choice == GlobalVariables.LayoffMotive.InapropriateBehaviour:
		if _report.layoff_round == EmployeeList.get_layoff_round():
			player_scored.emit(1)
		else:
			player_scored.emit(-1)
	elif _choice == GlobalVariables.LayoffMotive.BudgetCut:
		if _report.salary >= EmployeeList.get_average_salary(_report.department):
			player_scored.emit(1)
		else:
			player_scored.emit(-1)
	elif _choice == GlobalVariables.LayoffMotive.Improductivity:
		if _report.production_rate <= EmployeeList.get_average_productivity(_report.department):
			player_scored.emit(1)
		else:
			player_scored.emit(-1)

func close_inspection() -> void:
	if interaction_router:
		interaction_router.request_deselect()
	else:
		on_deselect()
