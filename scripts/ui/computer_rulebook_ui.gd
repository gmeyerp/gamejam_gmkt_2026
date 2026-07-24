class_name ComputerRulebookUI
extends Control

enum RulebookTab {
	BEHAVIOUR_RULES,
	DEPARTMENT_BUDGET,
	DEPARTMENT_PRODUCTIVITY,
}

@onready var _behaviour_tab: Button = $Panel/VBox/TabButtons/BehaviourTab
@onready var _budget_tab: Button = $Panel/VBox/TabButtons/BudgetTab
@onready var _productivity_tab: Button = $Panel/VBox/TabButtons/ProductivityTab
@onready var _behaviour_page: Label = $Panel/VBox/Pages/BehaviourPage
@onready var _budget_page: Label = $Panel/VBox/Pages/BudgetPage
@onready var _productivity_page: Label = $Panel/VBox/Pages/ProductivityPage
@export var rules : Array[AcceptableBehaviours]

var _current_tab: RulebookTab = RulebookTab.BEHAVIOUR_RULES


func _ready() -> void:
	_behaviour_tab.pressed.connect(switch_tab.bind(RulebookTab.BEHAVIOUR_RULES))
	_budget_tab.pressed.connect(switch_tab.bind(RulebookTab.DEPARTMENT_BUDGET))
	_productivity_tab.pressed.connect(switch_tab.bind(RulebookTab.DEPARTMENT_PRODUCTIVITY))
	_refresh_tab_visibility()


func show_ui() -> void:
	visible = true
	_refresh_tab_visibility()


func set_department_data(averages: Dictionary) -> void:
	if averages.is_empty():
		return
	if averages.has("behaviour"):
		_behaviour_page.text = str(averages["behaviour"])
	if averages.has("budget"):
		_budget_page.text = str(averages["budget"])
	if averages.has("productivity"):
		_productivity_page.text = str(averages["productivity"])

func update_wage_page():
	var budget_text = ""
	for i in GlobalVariables.Department.size():
		budget_text += "%s average wages: %d
		" % [GlobalVariables.Department.keys()[i], EmployeeList.get_average_salary(i)]
	_budget_page.text = budget_text

func update_productivity_page():
	var budget_text = ""
	for i in GlobalVariables.Department.size():
		budget_text += "%s average productivity: %d
		" % [GlobalVariables.Department.keys()[i], EmployeeList.get_average_productivity(i)]
	_productivity_page.text = budget_text

func update_behaviour_page():
	var round = EmployeeList.get_layoff_round()
	var rule_text = ""
	for i in range(rules.size()):
		rule_text += "%s
		" % rules[i].rule_description[round]
	_behaviour_page.text = rule_text
	print(rule_text)

func switch_tab(tab: RulebookTab) -> void:
	_current_tab = tab
	_refresh_tab_visibility()


func _refresh_tab_visibility() -> void:
	_behaviour_page.visible = _current_tab == RulebookTab.BEHAVIOUR_RULES
	_budget_page.visible = _current_tab == RulebookTab.DEPARTMENT_BUDGET
	_productivity_page.visible = _current_tab == RulebookTab.DEPARTMENT_PRODUCTIVITY
	
	update_productivity_page()
	update_wage_page()
	update_behaviour_page()
