class_name ReportDecisionUI
extends Control

signal layoff_chosen(motive: GlobalVariables.LayoffMotive)

@onready var _title: Label = $Panel/VBox/Title
@onready var _keep_button: Button = $Panel/VBox/KeepButton
@onready var _improductivity_button: Button = $Panel/VBox/ImproductivityButton
@onready var _budget_button: Button = $Panel/VBox/BudgetCutButton
@onready var _behaviour_button: Button = $Panel/VBox/BehaviourButton


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
		_title.text = "Relatório — %s" % employee.name
	else:
		_title.text = "Relatório — escolha:"
