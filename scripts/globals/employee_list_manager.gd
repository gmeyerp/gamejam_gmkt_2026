extends Node
class_name EmployeeListManager

signal employee_fired

@export var employee_list: Array[EmployeeData] = []

@onready var current_employees: Array[EmployeeData] = employee_list.duplicate()
var next_list: Array[EmployeeData] = []

func reset_list() -> Array[EmployeeData]:
	current_employees = employee_list.duplicate()
	next_list.clear()
	return current_employees.duplicate()

func get_average_productivity(department: GlobalVariables.Department) -> float:
	var sum: float = 0.0
	var workers: float = 0.0
	
	for emp in current_employees:
		if emp and emp.department == department:
			sum += emp.production_rate
			workers += 1.0
			
	for emp in next_list:
		if emp and emp.department == department:
			sum += emp.production_rate
			workers += 1.0
			
	if workers == 0.0:
		return 0.0
		
	var avg = sum / workers
	var dept_key = GlobalVariables.Department.keys()[department]
	print("Average Productivity %s: %.2f" % [dept_key, avg])
	return avg

func get_average_salary(department: GlobalVariables.Department) -> float:
	var sum: float = 0.0
	var workers: float = 0.0
	
	for emp in current_employees:
		if emp and emp.department == department:
			sum += emp.salary
			workers += 1.0
			
	for emp in next_list:
		if emp and emp.department == department:
			sum += emp.salary
			workers += 1.0
			
	if workers == 0.0:
		return 0.0
		
	var avg = sum / workers
	var dept_key = GlobalVariables.Department.keys()[department]
	print("Average Salary %s: %.2f" % [dept_key, avg])
	return avg

func get_employee_number() -> int:
	return current_employees.size() + next_list.size()

func add_next_round(employee: EmployeeData) -> void:
	if employee:
		next_list.append(employee)

func remove_from_list(employee: EmployeeData) -> void:
	current_employees.erase(employee)
	employee_fired.emit()

func start_new_round() -> void:
	current_employees = next_list.duplicate()
	next_list.clear()

func get_employee_list() -> Array[EmployeeData]:
	return current_employees.duplicate()
