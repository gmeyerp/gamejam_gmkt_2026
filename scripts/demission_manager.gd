extends Node
class_name DemissionManager

signal employee_selected(employee: EmployeeData)
signal game_finished

@onready var employee_list: Array[EmployeeData] = EmployeeList.get_employee_list()
var current_index: int = 0

func start_game() -> void:
	current_index = 0
	
	employee_list = EmployeeList.reset_list()
	employee_list.shuffle()
	
	print("--- INICIANDO NOVO JOGO ---")
	print("Ordem dos funcionários sorteados:")
	for i in range(employee_list.size()):
		var emp = employee_list[i]
		
		if not emp:
			continue
			
		print("  [%d] %s" % [i, emp.name])

	load_next_employee()

func load_next_employee() -> void:
	if current_index < employee_list.size():
		var current_employee: EmployeeData = employee_list[current_index]
		
		print(">> Funcionário Atual (%d/%d): %s" % [current_index + 1, employee_list.size(), current_employee.name])
		
		employee_selected.emit(current_employee)
		EmployeeList.get_average_productivity(current_employee.department)
		EmployeeList.get_average_salary(current_employee.department)
	else:
		EmployeeList.start_new_round()
		employee_list = EmployeeList.get_employee_list()
		if employee_list.size() == 0:
			print(">> Todos os funcionários foram processados!")
			game_finished.emit()
		else:
			start_new_round()

func start_new_round():
	employee_list.shuffle()
	current_index = 0
	load_next_employee()
	
func process_decision(motive_chosen: GlobalVariables.LayoffMotive) -> void:
	if current_index >= employee_list.size():
		return
	var current_employee: EmployeeData = employee_list[current_index]
	
	if motive_chosen == current_employee.layoff_motive:
		print(" Decisão CORRETA para %s" % current_employee.name)
	else:
		print(" Decisão ERRADA para %s" % current_employee.name)
	
	if motive_chosen == GlobalVariables.LayoffMotive.Keep:
		EmployeeList.add_next_round(current_employee)
	else:
		EmployeeList.remove_from_list(current_employee)
	
	current_index += 1
	load_next_employee()
