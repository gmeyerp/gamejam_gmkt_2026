class_name ReportDecisionUI
extends Control

signal layoff_chosen(motive: GlobalVariables.LayoffMotive)
@onready var employee_name: Label = $EmployeeInfo/Name
@onready var main_info: Label = $EmployeeInfo/MainInfo

@onready var _title: Label = %Title
@onready var _keep_button: Button = %KeepButton
@onready var _improductivity_button: Button = %ImproductivityButton
@onready var _budget_button: Button = %BudgetCutButton
@onready var _behaviour_button: Button = %BehaviourButton


func _ready() -> void:
	_keep_button.pressed.connect(
		func() -> void: layoff_chosen.emit(GlobalVariables.LayoffMotive.Keep)
	)
	_improductivity_button.pressed.connect(
		func() -> void: layoff_chosen.emit(GlobalVariables.LayoffMotive.Improductivity)
	)
	_budget_button.pressed.connect(
		func() -> void: layoff_chosen.emit(GlobalVariables.LayoffMotive.BudgetCut)
	)
	_behaviour_button.pressed.connect(
		func() -> void: layoff_chosen.emit(GlobalVariables.LayoffMotive.InapropriateBehaviour)
	)


func show_employee(employee: EmployeeData) -> void:
	visible = true
	if employee and not employee.name.is_empty():
		var comment := _get_employee_comment(employee)
		_title.text = "Decision for — %s" % employee.name
		employee_name.text = "Report
		%s | Age: %d" % [employee.name, employee.age]
		main_info.text = "Department: %s
		Productivity: %.2f
		Wage: %.2f
		Comment: %s
		" % [GlobalVariables.Department.keys()[employee.department],
		employee.production_rate, employee.salary, comment]
	
	else:
		if employee:
			_title.text = "Report — %s" % employee.name
		else:
			_title.text = "Report"


func _get_employee_comment(employee: EmployeeData) -> String:
	if not employee or employee.commentary.is_empty():
		return ""
	var round_idx: int = EmployeeList.get_layoff_round()
	if round_idx >= 0 and round_idx < employee.commentary.size():
		return employee.commentary[round_idx]
	return employee.commentary[employee.commentary.size() - 1]
