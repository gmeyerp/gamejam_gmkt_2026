extends Node
class_name DemissionManager

signal employee_selected(employee: EmployeeData)
signal employee_fired(employee: EmployeeData)

signal game_finished

@onready var employee_list: Array[EmployeeData] = EmployeeList.get_employee_list()
@export var boss_data: EmployeeData
@export var self_data: EmployeeData
var current_index: int = 0
var _session_active: bool = false
var fired_everyone: bool = false
var fired_boss: bool = false
var fired_self: bool = false
var current_employee: EmployeeData

func start_game() -> void:
	_session_active = true
	current_index = 0

	employee_list = EmployeeList.reset_list()
	employee_list.shuffle()

	print("--- INICIANDO NOVO JOGO ---")
	print("Ordem dos funcionários sorteados:")
	for i in range(employee_list.size()):
		var emp = employee_list[i]
		if emp:
			print("  [%d] %s" % [i, emp.name])

	load_next_employee()

func stop_game() -> void:
	_session_active = false
	current_index = 0

func load_next_employee() -> void:
	if not _session_active:
		return
	if current_index < employee_list.size():
		current_employee = employee_list[current_index]

		if not current_employee:
			current_index += 1
			load_next_employee()
			return

		print(">> Funcionário Atual (%d/%d): %s" % [current_index + 1, employee_list.size(), current_employee.name])
		employee_selected.emit(current_employee)
	else:
		EmployeeList.start_new_round()
		employee_list = EmployeeList.get_employee_list()
		if employee_list.size() == 0:
			print(">> Todos os funcionários foram processados!")
			fired_everyone = true
			if not fired_self and not fired_boss:
				load_special(boss_data)
			elif not fired_self:
				load_special(self_data)
			else:
				_session_active = false
				game_finished.emit()
		else:
			start_new_round()

func start_new_round() -> void:
	if not _session_active:
		return
	employee_list.shuffle()
	current_index = 0
	load_next_employee()

func process_decision(motive_chosen: GlobalVariables.LayoffMotive) -> void:
	if not _session_active:
		return
	
	if current_employee == boss_data and motive_chosen != GlobalVariables.LayoffMotive.Keep:
		fired_boss = true
		EmployeeList.reduce_special_employee()
	
	if current_employee == self_data and motive_chosen != GlobalVariables.LayoffMotive.Keep:
		fired_self = true
		EmployeeList.reduce_special_employee()

	if not fired_everyone:
		if current_index >= employee_list.size():
			return
		current_employee = employee_list[current_index]
	
		if motive_chosen == GlobalVariables.LayoffMotive.Keep:
			EmployeeList.add_next_round(current_employee)
		else:
			EmployeeList.remove_from_list(current_employee)
	if motive_chosen != GlobalVariables.LayoffMotive.Keep:
		employee_fired.emit(current_employee)

	current_index += 1
	await get_tree().create_timer(1.0).timeout
	if not _session_active:
		return
	load_next_employee()

func load_special(special: EmployeeData):
	employee_selected.emit(special)
	current_employee = special
